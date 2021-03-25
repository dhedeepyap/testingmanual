view: ibe_elements_derived {

  parameter: target_select {
    type: string
    default_value: "2"
    allowed_value: {
      label: "Macy's Apparel Segment 1"
      value: "1"
    }
    allowed_value: {
      label: "Macy's Apparel Segment 2"
      value: "2"
    }
    allowed_value: {
      label: "Macy's Apparel Segment 3"
      value: "3"
    }
    allowed_value: {
      label: "Macy's Apparel Segment 4"
      value: "4"
    }
  }

  parameter: reference_select {
    type: string
    default_value: "0"
    allowed_value: {
      label: "Standard Reference Population"
      value: "0"
    }
    allowed_value: {
      label: "Macy's Apparel Segment 1"
      value: "1"
    }
    allowed_value: {
      label: "Macy's Apparel Segment 2"
      value: "2"
    }
    allowed_value: {
      label: "Macy's Apparel Segment 3"
      value: "3"
    }
    allowed_value: {
      label: "Macy's Apparel Segment 4"
      value: "4"
    }
  }


  derived_table: {
    sql:
        WITH tab1 AS
        (
          SELECT
              target_flg
              ,ibe_elements.category AS category
              ,ibe_elements.key  AS key
              ,ibe_elements.value  AS value
              ,SUM(CASE WHEN (ib_hybrid_phu_test1.target_flg) = {{target_select._parameter_value}} THEN 1 ELSE 0 END) AS target_sum
              ,SUM(CASE WHEN (ib_hybrid_phu_test1.target_flg) = {{reference_select._parameter_value}} THEN 1 ELSE 0 END) AS reference_sum
          FROM `orange-iguana.prod.ib_hybrid_POC202001_5_v11` AS ib_hybrid_phu_test1
            ,UNNEST(ib_hybrid_phu_test1.ibe_elements) as ibe_elements
          --WHERE (ibe_elements.key ) IN ('Ethnicity','Gender','Race Code (Low Detail)')
          GROUP BY
              1,2,3,4
        )
        SELECT
          target_flg
          ,category
          ,key
          ,value
          ,target_sum
          ,reference_sum
          ,SUM(target_sum) OVER (PARTITION BY target_flg, category, key) AS target_total
          ,SUM(reference_sum) OVER (PARTITION BY target_flg, category, key) AS reference_total
        FROM tab1
      ;;
  }

  dimension: target_flg {
    type: string
    sql:  ${TABLE}.target_flg ;;
  }

  dimension: category {
    type: string
    sql:  ${TABLE}.category ;;
  }

  dimension: key {
    type: string
    sql:  ${TABLE}.key ;;
  }

  dimension: value {
    type: string
    sql:  ${TABLE}.value ;;
  }


  measure: target_sum {
    type: number
    #sql:SUM(CASE WHEN ${target_flg} = {{target_select._parameter_value}} THEN ${TABLE}.target_sum ELSE 0 END);;
    sql: SUM(${TABLE}.target_sum) ;;
  }

  measure: target_total {
    # sql_distinct_key:${ibe_interests} ;;
    type: number
    # sql:SUM(CASE WHEN ${target_flg} = {{target_select._parameter_value}} THEN ${TABLE}.target_total ELSE 0 END);;
    sql: SUM(${TABLE}.target_total) ;;
  }

  measure: reference_sum {
    type: number
    # sql:SUM(CASE WHEN ${target_flg} = {{reference_select._parameter_value}} THEN ${TABLE}.reference_sum ELSE 0 END);;
    sql: SUM(${TABLE}.reference_sum) ;;
  }

  measure: reference_total {
    type: number
    #sql:SUM(CASE WHEN ${target_flg} = {{reference_select._parameter_value}} THEN ${TABLE}.reference_total ELSE 0 END);;
    sql: SUM(${TABLE}.reference_total) ;;
  }


  measure: target_percent {
    type: number
    value_format_name: percent_1
    sql: (${target_sum}/NULLIF(${target_total},0));;
  }

  measure: reference_percent {
    # sql_distinct_key:${ibe_interests} ;;
    type: number
    value_format_name: percent_1
    sql: (${reference_sum}/NULLIF(${reference_total},0));;
  }

  measure: index {
    # sql_distinct_key:${ibe_interests} ;;
    type: number
    value_format_name: id
    sql: (${target_percent}/NULLIF(${reference_percent},0)) * 100;;
  }

  measure: ibe_weighted_index {
    # sql_distinct_key:${ibe_interests} ;;
    type: number
    value_format_name: id
    sql: (${index}*${target_percent});;
  }

}
