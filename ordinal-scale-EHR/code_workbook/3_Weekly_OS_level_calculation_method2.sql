/* 
   Author: Maryam Khodaverdi 
   Date: 05/21
   Desc: weekly OS level of pts 
*/

with all_days as (

select distinct
    pts.person_id
    , pts.date_of_earliest_covid_diagnosis
    , floor(datediff(hosp.hosp_start_date, pts.date_of_earliest_covid_diagnosis)/7)+1 as hosp_weekfromdx
    , floor(datediff(hosp.hosp_end_date, pts.date_of_earliest_covid_diagnosis)/7)+1 as hosp_end_weekfromdx
    , datediff(hosp.hosp_start_date, pts.date_of_earliest_covid_diagnosis) as hosp_daysfromdx
    , datediff(hosp.hosp_end_date, pts.date_of_earliest_covid_diagnosis) as hosp_end_daysfromdx

    , floor(datediff(oxy.oxy_start_date, pts.date_of_earliest_covid_diagnosis)/7)+1 as oxy_weekfromdx
    , floor(datediff(oxy.oxy_end_date, pts.date_of_earliest_covid_diagnosis)/7)+1 as oxy_end_weekfromdx
    , datediff(oxy.oxy_start_date, pts.date_of_earliest_covid_diagnosis) as oxy_daysfromdx
    , datediff(oxy.oxy_end_date, pts.date_of_earliest_covid_diagnosis) as oxy_end_daysfromdx

    , datediff(vent.vent_start_date, pts.date_of_earliest_covid_diagnosis) as vent_daysfromdx 

    , floor(datediff(ecmo.ecmo_start_date, pts.date_of_earliest_covid_diagnosis)/7)+1 as ecmo_weekfromdx
    , floor(datediff(ecmo.ecmo_end_date, pts.date_of_earliest_covid_diagnosis)/7)+1 as ecmo_end_weekfromdx
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
all_weeks as (
    select 
        person_id 
        , case when (1 between hosp_weekfromdx and hosp_end_weekfromdx) then 3 else 0 end as hosp_week1 
        , case when (2 between hosp_weekfromdx and hosp_end_weekfromdx) then 3 else 0 end as hosp_week2 
        , case when (3 between hosp_weekfromdx and hosp_end_weekfromdx) then 3 else 0 end as hosp_week3 
        , case when (4 between hosp_weekfromdx and hosp_end_weekfromdx) then 3 else 0 end as hosp_week4 

        , case when (1 between oxy_weekfromdx and oxy_end_weekfromdx) then 5 else 0 end as oxy_week1 
        , case when (2 between oxy_weekfromdx and oxy_end_weekfromdx) then 5 else 0 end as oxy_week2 
        , case when (3 between oxy_weekfromdx and oxy_end_weekfromdx) then 5 else 0 end as oxy_week3 
        , case when (4 between oxy_weekfromdx and oxy_end_weekfromdx) then 5 else 0 end as oxy_week4 
        
        , case when vent_daysfromdx <7 then 7 else 0 end as vent_week1
        , case when (vent_daysfromdx <14 and vent_daysfromdx>=7) then 7 else 0 end as vent_week2
        , case when (vent_daysfromdx <21 and vent_daysfromdx>=14) then 7 else 0 end as vent_week3
        , case when (vent_daysfromdx <28 and vent_daysfromdx>=21) then 7 else 0 end as vent_week4

        , case when (1 between ecmo_weekfromdx and ecmo_end_weekfromdx) then 9 else 0 end as ecmo_week1 
        , case when (2 between ecmo_weekfromdx and ecmo_end_weekfromdx) then 9 else 0 end as ecmo_week2 
        , case when (3 between ecmo_weekfromdx and ecmo_end_weekfromdx) then 9 else 0 end as ecmo_week3 
        , case when (4 between ecmo_weekfromdx and ecmo_end_weekfromdx) then 9 else 0 end as ecmo_week4
        
        , case when death_daysfromdx <7 then 11 else 0 end as death_week1
        , case when (death_daysfromdx <14 and death_daysfromdx>=7) then 11 else 0 end as death_week2
        , case when (death_daysfromdx <21 and death_daysfromdx>=14) then 11 else 0 end as death_week3
        , case when (death_daysfromdx <28 and death_daysfromdx>=21) then 11 else 0 end as death_week4

        , case when (0 between hosp_daysfromdx and hosp_end_daysfromdx) then 3 else 0 end as hosp_start_week1
        , case when (0 between oxy_daysfromdx and oxy_end_daysfromdx) then 5 else 0 end as oxy_start_week1
        , case when vent_daysfromdx =0 then 7 else 0 end as vent_start_week1
        , case when (0 between ecmo_daysfromdx and ecmo_end_daysfromdx) then 9 else 0 end as ecmo_start_week1
        , case when death_daysfromdx =0 then 11 else 0 end as death_start_week1

        , case when (6 between hosp_daysfromdx and hosp_end_daysfromdx) then 3 else 0 end as hosp_end_week1
        , case when (6 between oxy_daysfromdx and oxy_end_daysfromdx) then 5 else 0 end as oxy_end_week1
        , case when vent_daysfromdx =6 then 7 else 0 end as vent_end_week1
        , case when (6 between ecmo_daysfromdx and ecmo_end_daysfromdx) then 9 else 0 end as ecmo_end_week1
        , case when death_daysfromdx =6 then 11 else 0 end as death_end_week1

        , case when (13 between hosp_daysfromdx and hosp_end_daysfromdx) then 3 else 0 end as hosp_end_week2
        , case when (13 between oxy_daysfromdx and oxy_end_daysfromdx) then 5 else 0 end as oxy_end_week2
        , case when vent_daysfromdx =13 then 7 else 0 end as vent_end_week2
        , case when (13 between ecmo_daysfromdx and ecmo_end_daysfromdx) then 9 else 0 end as ecmo_end_week2
        , case when death_daysfromdx =13 then 11 else 0 end as death_end_week2
        
        , case when (20 between hosp_daysfromdx and hosp_end_daysfromdx) then 3 else 0 end as hosp_end_week3 
        , case when (20 between oxy_daysfromdx and oxy_end_daysfromdx) then 5 else 0 end as oxy_end_week3
        , case when vent_daysfromdx =20 then 7 else 0 end as vent_end_week3
        , case when (20 between ecmo_daysfromdx and ecmo_end_daysfromdx) then 9 else 0 end as ecmo_end_week3
        , case when death_daysfromdx =20 then 11 else 0 end as death_end_week3

        , case when (27 between hosp_daysfromdx and hosp_end_daysfromdx) then 3 else 0 end as hosp_end_week4 
        , case when (27 between oxy_daysfromdx and oxy_end_daysfromdx) then 5 else 0 end as oxy_end_week4
        , case when vent_daysfromdx =27 then 7 else 0 end as vent_end_week4
        , case when (27 between ecmo_daysfromdx and ecmo_end_daysfromdx) then 9 else 0 end as ecmo_end_week4
        , case when death_daysfromdx =27 then 11 else 0 end as death_end_week4
    from all_days

),
max_weeks as (
    select 
        person_id
        , max(hosp_week1) as hosp_week1
        , max(hosp_week2) as hosp_week2
        , max(hosp_week3) as hosp_week3
        , max(hosp_week4) as hosp_week4
        , max(oxy_week1) as oxy_week1
        , max(oxy_week2) as oxy_week2
        , max(oxy_week3) as oxy_week3
        , max(oxy_week4) as oxy_week4
        , max(vent_week1) as vent_week1
        , max(vent_week2) as vent_week2
        , max(vent_week3) as vent_week3
        , max(vent_week4) as vent_week4
        , max(ecmo_week1) as ecmo_week1
        , max(ecmo_week2) as ecmo_week2
        , max(ecmo_week3) as ecmo_week3
        , max(ecmo_week4) as ecmo_week4
        , max(death_week1) as death_week1
        , max(death_week2) as death_week2
        , max(death_week3) as death_week3
        , max(death_week4) as death_week4

        , max(hosp_start_week1) as hosp_start_week1
        , max(oxy_start_week1) as oxy_start_week1
        , max(vent_start_week1) as vent_start_week1
        , max(ecmo_start_week1) as ecmo_start_week1
        , max(death_start_week1) as death_start_week1

        , max(hosp_end_week1) as hosp_end_week1
        , max(oxy_end_week1) as oxy_end_week1
        , max(vent_end_week1) as vent_end_week1
        , max(ecmo_end_week1) as ecmo_end_week1
        , max(death_end_week1) as death_end_week1

        , max(hosp_end_week2) as hosp_end_week2
        , max(oxy_end_week2) as oxy_end_week2
        , max(vent_end_week2) as vent_end_week2
        , max(ecmo_end_week2) as ecmo_end_week2
        , max(death_end_week2) as death_end_week2

        , max(hosp_end_week3) as hosp_end_week3
        , max(oxy_end_week3) as oxy_end_week3
        , max(vent_end_week3) as vent_end_week3
        , max(ecmo_end_week3) as ecmo_end_week3
        , max(death_end_week3) as death_end_week3

        , max(hosp_end_week4) as hosp_end_week4
        , max(oxy_end_week4) as oxy_end_week4
        , max(vent_end_week4) as vent_end_week4
        , max(ecmo_end_week4) as ecmo_end_week4
        , max(death_end_week4) as death_end_week4 
    from all_weeks
    group by person_id

), 
os_weeks as (
    select distinct
        person_id
        , case when death_week1>=11 then 11
            when (ecmo_week1>=9 and death_week1<=0 ) then 9
            when (vent_week1>=7 and ecmo_week1<=0 and death_week1<=0) then 7
            when (oxy_week1>=5 and vent_week1<=0 and ecmo_week1<=0 and death_week1<=0 ) then 5
            when (hosp_week1>=3 and oxy_week1<=0 and vent_week1<=0 and ecmo_week1<=0 and death_week1<=0 ) then 3
            else 1
        end as week1
        , case when death_week2>=11 then 11
            when death_week1>=11 then 11
            when (ecmo_week2>=9 and death_week2<=0) then 9
            when (vent_week2>=7 and ecmo_week2<=0 and death_week2<=0) then 7
            when (oxy_week2>=5 and vent_week2<=0 and ecmo_week2<=0 and death_week2<=0) then 5
            when (hosp_week2>=3 and oxy_week2<=0 and vent_week2<=0 and ecmo_week2<=0 and death_week2<=0) then 3
            else 1
        end as week2
        , case when death_week3>=11 then 11
            when (death_week1>=11 or death_week2>=11) then 11
            when (ecmo_week3>=9 and death_week3<=0) then 9
            when (vent_week3>=7 and ecmo_week3<=0 and death_week3<=0) then 7
            when (oxy_week3>=5 and vent_week3<=0 and ecmo_week3<=0 and death_week3<=0) then 5
            when (hosp_week3>=3 and oxy_week3<=0 and vent_week3<=0 and ecmo_week3<=0 and death_week3<=0) then 3
            else 1
        end as week3
        , case when death_week4>=11 then 11
            when (death_week1>=11 or death_week2>=11 or death_week3>=11) then 11
            when (ecmo_week4>=9 and death_week4<=0) then 9
            when (vent_week4>=7 and ecmo_week4<=0 and death_week4<=0) then 7
            when (oxy_week4>=5 and vent_week4<=0 and ecmo_week4<=0 and death_week4<=0) then 5
            when (hosp_week4>=3 and oxy_week4<=0 and vent_week4<=0 and ecmo_week4<=0 and death_week4<=0) then 3
            else 1
        end as week4
        , case when death_start_week1>=11 then 11
            when (ecmo_start_week1>=9 and death_start_week1<=0) then 9
            when (vent_start_week1>=7 and ecmo_start_week1<=0 and death_start_week1<=0) then 7
            when (oxy_start_week1>=5 and vent_start_week1<=0 and ecmo_start_week1<=0 and death_start_week1<=0) then 5
            when (hosp_start_week1>=3 and oxy_start_week1<=0 and vent_start_week1<=0 and ecmo_start_week1<=0 and death_start_week1<=0) then 3
            else 1
        end as week1_startday
        , case when death_end_week1>=11 then 11
            when (death_week1>=11) then 11
            when (ecmo_end_week1>=9 and death_end_week1<=0) then 9
            when (vent_end_week1>=7 and ecmo_end_week1<=0 and death_end_week1<=0) then 7
            when (oxy_end_week1>=5 and vent_end_week1<=0 and ecmo_end_week1<=0 and death_end_week1<=0) then 5
            when (hosp_end_week1>=3 and oxy_end_week1<=0 and vent_end_week1<=0 and ecmo_end_week1<=0 and death_end_week1<=0) then 3
            else 1
        end as week1_endday
        , case when death_end_week2>=11 then 11
            when (death_week1>=11 or death_week2>=11) then 11
            when (ecmo_end_week2>=9 and death_end_week2<=0) then 9
            when (vent_end_week2>=7 and ecmo_end_week2<=0 and death_end_week2<=0) then 7
            when (oxy_end_week2>=5 and vent_end_week2<=0 and ecmo_end_week2<=0 and death_end_week2<=0) then 5
            when (hosp_end_week2>=3 and oxy_end_week2<=0 and vent_end_week2<=0 and ecmo_end_week2<=0 and death_end_week2<=0) then 3
            else 1
        end as week2_endday
        , case when death_end_week3>=11 then 11
            when (death_week1>=11 or death_week2>=11 or death_week3>=11) then 11
            when (ecmo_end_week3>=9 and death_end_week3<=0) then 9
            when (vent_end_week3>=7 and ecmo_end_week3<=0 and death_end_week3<=0) then 7
            when (oxy_end_week3>=5 and vent_end_week3<=0 and ecmo_end_week3<=0 and death_end_week3<=0) then 5
            when (hosp_end_week3>=3 and oxy_end_week3<=0 and vent_end_week3<=0 and ecmo_end_week3<=0 and death_end_week3<=0) then 3
            else 1
        end as week3_endday
        , case when death_end_week4>=11 then 11
            when (death_week1>=11 or death_week2>=11 or death_week3>=11 or death_week4>=11) then 11
            when (ecmo_end_week4>=9 and death_end_week4<=0) then 9
            when (vent_end_week4>=7 and ecmo_end_week4<=0 and death_end_week4<=0) then 7
            when (oxy_end_week4>=5 and vent_end_week4<=0 and ecmo_end_week4<=0 and death_end_week4<=0) then 5
            when (hosp_end_week4>=3 and oxy_end_week4<=0 and vent_end_week4<=0 and ecmo_end_week4<=0 and death_end_week4<=0) then 3
            else 1
        end as week4_endday
    from max_weeks

) 
select distinct 
    person_id
    , max(week1) as week1
    , max(week2) as week2
    , max(week3) as week3
    , max(week4) as week4

    , max(week1_startday) as week1_startday
    , max(week1_endday) as week1_endday
    , max(week2_endday) as week2_endday
    , max(week3_endday) as week3_endday
    , max(week4_endday) as week4_endday
from os_weeks
group by person_id


