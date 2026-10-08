-- SplitShare backend schema for Supabase (Postgres). Paste into the SQL editor and run once.
-- Passwords are handled by Supabase Auth (hashed server-side). The app never stores them.
-- Amounts are stored in paise. Trip total and balances are computed from expenses (no duplicated totals).

create table profiles (
  id uuid primary key references auth.users on delete cascade,
  first_name text not null, last_name text not null, mobile text, email text
);

create table trips (
  id uuid primary key default gen_random_uuid(),
  owner uuid not null default auth.uid() references auth.users on delete cascade,
  name text not null, trip_date date not null default current_date, created_at timestamptz default now()
);

create table participants (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips on delete cascade, name text not null
);

create table expenses (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips on delete cascade,
  description text not null, amount_paise bigint not null check (amount_paise > 0),
  paid_by uuid not null references participants, shared_by uuid[] not null, created_at timestamptz default now()
);

create table settlements (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips on delete cascade,
  from_participant uuid not null references participants, to_participant uuid not null references participants,
  amount_paise bigint not null, status text not null default 'pending' check (status in ('pending','settled')),
  settled_at timestamptz, unique (trip_id, from_participant, to_participant)
);

-- Row-level security: every row is reachable only by the trip's owner.
alter table profiles enable row level security;
alter table trips enable row level security;
alter table participants enable row level security;
alter table expenses enable row level security;
alter table settlements enable row level security;

create policy "own profile" on profiles for all using (id = auth.uid()) with check (id = auth.uid());
create policy "own trips" on trips for all using (owner = auth.uid()) with check (owner = auth.uid());

do $$ declare t text; begin
  foreach t in array array['participants','expenses','settlements'] loop
    execute format(
      'create policy "own %1$s" on %1$I for all
         using (exists (select 1 from trips where trips.id = %1$I.trip_id and trips.owner = auth.uid()))
         with check (exists (select 1 from trips where trips.id = %1$I.trip_id and trips.owner = auth.uid()))', t);
  end loop;
end $$;

-- Create the profile row automatically when someone registers (pass names/mobile as signUp metadata).
create function handle_new_user() returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into profiles (id, first_name, last_name, mobile, email)
  values (new.id, new.raw_user_meta_data->>'first_name', new.raw_user_meta_data->>'last_name',
          new.raw_user_meta_data->>'mobile', new.email);
  return new;
end $$;
create trigger on_auth_user_created after insert on auth.users for each row execute function handle_new_user();
