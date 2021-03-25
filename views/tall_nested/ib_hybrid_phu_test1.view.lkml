include: "/views/tall_nested/*.view.lkml"
include: "/views/orange_iguana_POC202001_1.view.lkml"



explore: ibe_elements_derived {
  # cancel_grouping_fields: [ib_hybrid_phu_test1.gender_kpi]

}

explore: ib_hybrid_phu_test1 {
  # cancel_grouping_fields: [ib_hybrid_phu_test1.gender_kpi]

  # Repeated nested object
  join: ibe_elements {
    view_label: "InfoBase Elements (Tall)"
    sql: ,UNNEST(${ib_hybrid_phu_test1.ibe_elements}) as ibe_elements ;;
    relationship: one_to_many
  }
  join: ibe_interests {
    view_label: "InfoBase Interests (Tall)"
    sql: ,UNNEST(${ib_hybrid_phu_test1.ibe_interests}) as ibe_interests ;;
    relationship: one_to_many
  }
  join: ibe_demographic {
    view_label: "Demographic (Tall)"
    sql: ,UNNEST(${ib_hybrid_phu_test1.ibe_demographic}) as ibe_demographic ;;
    relationship: one_to_many
  }
  join: ibe_aps {
    view_label: "Audience Propensities (Tall)"
    sql: ,UNNEST(${ib_hybrid_phu_test1.ibe_aps}) as ibe_aps ;;
    relationship: one_to_many
  }
  join: ibe_spending {
    view_label: "Spending (Tall)"
    sql: ,UNNEST(${ib_hybrid_phu_test1.ibe_spending}) as ibe_spending ;;
    relationship: one_to_many
  }
  join: ibe_media {
    view_label: "Media (Tall)"
    sql: ,UNNEST(${ib_hybrid_phu_test1.ibe_media}) as ibe_media ;;
    relationship: one_to_many
  }
  join: ibe_vehicle {
    view_label: "Vehicle (Tall)"
    sql: ,UNNEST(${ib_hybrid_phu_test1.ibe_vehicle}) as ibe_vehicle ;;
    relationship: one_to_many
  }
  join: ibe_household {
    view_label: "Household (Tall)"
    sql: ,UNNEST(${ib_hybrid_phu_test1.ibe_household}) as ibe_household ;;
    relationship: one_to_many
  }
  join: ibe_financial {
    view_label: "Financial (Tall)"
    sql: ,UNNEST(${ib_hybrid_phu_test1.ibe_financial}) as ibe_financial ;;
    relationship: one_to_many
  }
}
