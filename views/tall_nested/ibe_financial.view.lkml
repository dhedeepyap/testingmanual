view: ibe_financial {
  sql_table_name: `orange-iguana.prod.ib_hybrid_POC202001_5_v11`;;

  dimension: id {
    primary_key: yes
    hidden: yes
    sql: CONCAT(CAST(${key} AS STRING),'|', CAST(${value} AS STRING)) ;;
  }

  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }
  dimension: value {
    type: string
    sql: ${TABLE}.value;;
  }
  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }
  dimension: subcategory {
    type: string
    sql: ${TABLE}.subcategory ;;
  }

  dimension: target_flg {
    type: string
    # ${TABLE}.cib8609_marital_status
    # sql: CASE WHEN LOWER(${cib8609_marital_status}) LIKE '%single%' THEN 1 ELSE 0 END ;;
    sql:  ${ib_hybrid_phu_test1.target_flg};;
    # sql: CASE WHEN (floor(rand()*100)+1) > 25 THEN 1 ELSE 0 END ;;
  }


###############################################################################################
###  FINANCE TALL CALCS
###############################################################################################

  # This logic helps fix some of the non-numeric values we are using in the tall data.
  # NEED TO FIX IN THE SOURCE DATA - REPOINT TOWARDS PROPER NIB ELEMENTS !!!
  dimension: ibe_financial_value {
    type: number
    sql:  CASE WHEN LOWER(${ibe_financial.value}) LIKE '%not confirmed%' THEN 0
                WHEN LOWER(${ibe_financial.value}) = 'missing' THEN 0
                WHEN ${ibe_financial.value} IS NULL THEN 0
                WHEN ${ibe_financial.value} = "0" THEN 0
                WHEN ${ibe_financial.key} = 'Heavy Transactors' THEN 0
                ELSE 1 END ;;
  }

  measure: financial_target_sum {
    type: number
    sql:SUM(CASE WHEN ${target_flg} = {% parameter ib_hybrid_phu_test1.target_select %} THEN ${ibe_financial_value} ELSE 0 END);;
  }

  measure: financial_target_count {
    # sql_distinct_key:${ibe_interests} ;;
    type: number
    sql:SUM(CASE WHEN ${target_flg} = {% parameter ib_hybrid_phu_test1.target_select %} THEN 1 ELSE 0 END);;
  }

  measure: financial_reference_sum {
    type: number
    sql:SUM(CASE WHEN ${target_flg} = {% parameter ib_hybrid_phu_test1.refrence_select %} THEN ${ibe_financial_value} ELSE 0 END);;
  }

  measure: financial_reference_count {
    type: number
    sql:SUM(CASE WHEN ${target_flg} = {% parameter ib_hybrid_phu_test1.refrence_select %} THEN 1 ELSE 0 END);;
  }

  measure: financial_percent_of_total_target {
    type: number
    value_format_name: percent_1
    sql: (${financial_target_sum}/NULLIF(${financial_target_count},0));;
  }

  measure: financial_percent_of_total_reference {
    # sql_distinct_key:${ibe_interests} ;;
    type: number
    value_format_name: percent_1
    sql: (${financial_reference_sum}/NULLIF(${financial_reference_count},0));;
  }

  measure: financial_index {
    # sql_distinct_key:${ibe_interests} ;;
    type: percent_of_total
    value_format_name: decimal_1
    sql: (${financial_percent_of_total_target}/NULLIF(${financial_percent_of_total_reference},0)) * 100;;
  }

  measure: financial_index_html {
    type: percent_of_total
    value_format_name: decimal_0
    sql: (${financial_percent_of_total_target}/NULLIF(${financial_percent_of_total_reference},0)) * 100;;
    html:
          {% if value <= 20 %}
          <p><font style="color:#cccccc">{{rendered_value}}</font><img src="https://storage.googleapis.com/orange-iguana-image-host/oi-viz-icons/icon-index-chevron-down-3.png" height:20 width=20></p>
          {% elsif value > 20 and value <= 50 %}
          <p><font style="color:#cccccc">{{rendered_value}}</font><img src="https://storage.googleapis.com/orange-iguana-image-host/oi-viz-icons/icon-index-chevron-down-2.png" height:20 width=20></p>
          {% elsif value > 50 and value <= 80 %}
          <p><font style="color:#cccccc">{{rendered_value}}</font><img src="https://storage.googleapis.com/orange-iguana-image-host/oi-viz-icons/icon-index-chevron-down-1.png" height:20 width=20></p>
          {% elsif value > 80 and value <= 120 %}
          <p><font style="color:#cccccc">{{rendered_value}}</font><img src="https://storage.googleapis.com/orange-iguana-image-host/oi-viz-icons/icon-index-chevron-none.png" height:20 width=20></p>
          {% elsif value > 120 and value <= 180 %}
          <p><font style="color:#cccccc">{{rendered_value}}</font><img src="https://storage.googleapis.com/orange-iguana-image-host/oi-viz-icons/icon-index-chevron-up-1.png" height:20 width=20></p>
          {% elsif value > 180 and value <= 250 %}
          <p><font style="color:#cccccc">{{rendered_value}}</font><img src="https://storage.googleapis.com/orange-iguana-image-host/oi-viz-icons/icon-index-chevron-up-2.png" height:20 width=20></p>
          {% else %}
          <p><font style="color:#cccccc">{{rendered_value}}</font><img src="https://storage.googleapis.com/orange-iguana-image-host/oi-viz-icons/icon-index-chevron-up-3.png" height:20 width=20></p>
          {% endif %}
          ;;
  }
}
