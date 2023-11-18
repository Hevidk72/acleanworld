drop view public.user_get_trips;

create view
  public.user_get_trips as
select
  t.user_id,
  p.username,
  p.full_name,
  p.website,
  u.email,
  extract(
    days
    from
      now() - t.created_at 
  ) as trip_age_days,
  now() - t.created_at as trip_age_detail,
  t.stop_date - t.start_date as trip_duration,
  t.trip_data,
  t.description
from
  trips_tab t,
  profiles_tab p,
  auth.users u
where
  t.user_id = p.id
  and t.user_id = u.id
order by
  (
    extract(
      days
      from
        now() - t.created_at
    )
  );