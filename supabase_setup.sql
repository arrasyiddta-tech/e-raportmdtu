-- Jalankan di Supabase SQL Editor. Jangan letakkan kredensial service_role di HTML.
create table if not exists public.eraport_organizations (
 id uuid primary key default gen_random_uuid(), name text not null,
 payload jsonb not null default '{}'::jsonb, revision bigint not null default 0,
 updated_at timestamptz not null default now()
);
create table if not exists public.eraport_members (
 org_id uuid not null references public.eraport_organizations(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 role text not null check (role in ('admin','operator','guru')),
 primary key(org_id,user_id)
);
alter table public.eraport_organizations enable row level security;
alter table public.eraport_members enable row level security;
revoke all on public.eraport_organizations from anon, authenticated;
revoke all on public.eraport_members from anon, authenticated;
create or replace function public.eraport_pull(p_org uuid)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare result jsonb;
begin
 if auth.uid() is null or not exists(select 1 from public.eraport_members where org_id=p_org and user_id=auth.uid()) then raise exception 'Tidak diizinkan'; end if;
 select jsonb_build_object('payload',payload,'revision',revision) into result from public.eraport_organizations where id=p_org;
 return result;
end $$;
create or replace function public.eraport_push(p_org uuid,p_expected_revision bigint,p_payload jsonb)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare rev bigint;
begin
 if auth.uid() is null or not exists(select 1 from public.eraport_members where org_id=p_org and user_id=auth.uid() and role in ('admin','operator')) then raise exception 'Tidak diizinkan mengirim'; end if;
 update public.eraport_organizations set payload=p_payload,revision=revision+1,updated_at=now()
 where id=p_org and revision=p_expected_revision returning revision into rev;
 if rev is null then return jsonb_build_object('ok',false,'conflict',true); end if;
 return jsonb_build_object('ok',true,'revision',rev);
end $$;
revoke all on function public.eraport_pull(uuid) from public, anon;
revoke all on function public.eraport_push(uuid,bigint,jsonb) from public, anon;
grant execute on function public.eraport_pull(uuid) to authenticated;
grant execute on function public.eraport_push(uuid,bigint,jsonb) to authenticated;
-- Buat organisasi: insert into public.eraport_organizations(name) values ('MDTU AR-RASYID') returning id;
-- Setelah user terdaftar pada Authentication > Users, beri akses:
-- insert into public.eraport_members(org_id,user_id,role) values ('UUID_ORGANISASI','UUID_USER','admin');
