view: ibe_interests {
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


  dimension: target_flg {
    type: string
    # ${TABLE}.cib8609_marital_status
    # sql: CASE WHEN LOWER(${cib8609_marital_status}) LIKE '%single%' THEN 1 ELSE 0 END ;;
    sql:  ${ib_hybrid_phu_test1.target_flg};;
    # sql: CASE WHEN (floor(rand()*100)+1) > 25 THEN 1 ELSE 0 END ;;
  }

  measure: target_count {
    type: number
    #sql: sum(${target_flg})
    sql: SUM(CASE WHEN {% parameter ib_hybrid_phu_test1.target_select %} = ${target_flg} THEN 1 ELSE 0 END)
      ;;
  }

  measure: target_sum_i {
    type: number
    sql:SUM(CASE WHEN ${target_flg} = {% parameter ib_hybrid_phu_test1.target_select %} THEN cast(${ibe_interests.value} as int64 ) ELSE 0 END);;
  }

  measure: target_count_i {
    # sql_distinct_key:${ibe_interests} ;;
    type: number
    sql:SUM(CASE WHEN ${target_flg} = {% parameter ib_hybrid_phu_test1.target_select %} THEN 1 ELSE 0 END);;
  }

  measure: reference_sum_i {
    type: number
    sql:SUM(CASE WHEN ${target_flg} = {% parameter ib_hybrid_phu_test1.refrence_select %} THEN cast(${ibe_interests.value} as int64 ) ELSE 0 END);;
  }

  measure: reference_count_i {
    type: number
    sql:SUM(CASE WHEN ${target_flg} = {% parameter ib_hybrid_phu_test1.refrence_select %} THEN 1 ELSE 0 END);;
  }

  measure: percent_of_total_target {
    type: number
    value_format_name: percent_1
    sql:  ${target_count} / SUM(${target_count}) OVER() ;;
  }


  measure: percent_of_total_target_i {
    type: number
    value_format_name: percent_1
    sql: (${target_sum_i}/NULLIF(${target_count_i},0));;
  }

  measure: percent_of_total_reference_i {
    # sql_distinct_key:${ibe_interests} ;;
    type: number
    value_format_name: percent_1
    sql: (${reference_sum_i}/NULLIF(${reference_count_i},0));;
  }

  measure: index_i {
    # sql_distinct_key:${ibe_interests} ;;
    type: percent_of_total
    value_format_name: decimal_1
    sql: (${percent_of_total_target_i}/NULLIF(${percent_of_total_reference_i},0)) * 100;;
  }

  measure: index_i_html {
    type: percent_of_total
    value_format_name: decimal_0
    sql: (${percent_of_total_target_i}/NULLIF(${percent_of_total_reference_i},0)) * 100;;
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


  # measure: target_pct_bar {
  #   description: "Same as target percentage but renders as a bar"
  #   sql: ${percent_of_total_target} ;;
  #   view_label: "Visual Fields"
  #   type: number
  #   value_format_name: percent_1
  #   html: <div class="container-fluid" style="height:{{circle_size._parameter_value}}px;"><div class="progress" style="line-height:{{circle_size._parameter_value}}px; height:{{circle_size._parameter_value}}px;">
  #         <div class="progress-bar" role="progressbar" aria-valuenow="{{ value | times: 100 }}" aria-valuemin="0" aria-valuemax="100" style="background-color:#8EA6BB !important; width:{{ value | times: 100 }}%">
  #         <span style="float:left;text-align:center;font-size:{{font_size._parameter_value}}px !important;color:{{font_color._parameter_value}};line-height:{{circle_size._parameter_value}}px; height:{{circle_size._parameter_value}}px;">{{rendered_value}}</span>
  #         </div>
  #         </div></div> ;;
  # }




}
