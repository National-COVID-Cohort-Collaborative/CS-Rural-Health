/* 
   Author: Maryam Khodaverdi 
   Date: 06/21
   Desc: daily OS level of pts 
*/

with days_as_rows as (
    select distinct
        pts.person_id
        , pts.date_of_earliest_covid_diagnosis
        , dtb.data_partner_id
        , datediff(hosp.hosp_start_date, pts.date_of_earliest_covid_diagnosis) as hosp_daysfromdx
        , datediff(hosp.hosp_end_date, pts.date_of_earliest_covid_diagnosis) as hosp_end_daysfromdx
        , datediff(oxy.oxy_start_date, pts.date_of_earliest_covid_diagnosis) as oxy_daysfromdx
        , datediff(oxy.oxy_end_date, pts.date_of_earliest_covid_diagnosis) as oxy_end_daysfromdx
        , datediff(vent.vent_start_date, pts.date_of_earliest_covid_diagnosis) as vent_daysfromdx 
        , datediff(ecmo.ecmo_start_date, pts.date_of_earliest_covid_diagnosis) as ecmo_daysfromdx
        , datediff(ecmo.ecmo_end_date, pts.date_of_earliest_covid_diagnosis) as ecmo_end_daysfromdx 
        , datediff(date_add(dtb.death_date,0), pts.date_of_earliest_covid_diagnosis) as death_daysfromdx

    from covid_positive_with_index pts 
        left join death dtb                        on pts.person_id= dtb.person_id 
        left join Covid_pos_hospitalization hosp   on pts.person_id= hosp.person_id
        left join Covid_pos_oxygen oxy             on pts.person_id= oxy.person_id
        left join Covid_pos_ventilator vent        on pts.person_id= vent.person_id
        left join Covid_pos_ecmo ecmo              on pts.person_id= ecmo.person_id   
 
), 
 days_as_rows_dfilter as(
     select *, 
        case when death_daysfromdx <0 then 0
            else death_daysfromdx
        end as death_daysfromdx2
     from days_as_rows

),
 days_as_str as(
     select
        p.person_id
        , date_of_earliest_covid_diagnosis
        , concat_ws(',', array_sort(array_distinct(flatten(collect_set( sequence(hosp_daysfromdx, hosp_end_daysfromdx)) )))) as hsp_days
        , concat_ws(',', array_sort(array_distinct(flatten(collect_set( sequence(oxy_daysfromdx, oxy_end_daysfromdx)) )))) as oxy_days
        , concat_ws(',', array_sort(array_distinct(collect_set(vent_daysfromdx)))) as vent_days
        , concat_ws(',', array_sort(array_distinct(flatten(collect_set( sequence(ecmo_daysfromdx, ecmo_end_daysfromdx)) )))) as ecmo_days
        , concat_ws(',', array_sort(array_distinct(collect_set(death_daysfromdx)))) as death_days
    from days_as_rows_dfilter p
    group by p.person_id, date_of_earliest_covid_diagnosis
 
)
select * from days_as_str 


