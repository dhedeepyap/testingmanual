connection: "dsdv_psd_orange_iguana"

include: "/views/*.view.lkml"
include: "/*.dashboard.lookml"
include: "/views/orange_iguana_POC202001_1.view.lkml"




datagroup: orange_iguana_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "72 hours"
  sql_trigger: SELECT max(consumer_link_sha256) FROM `orange-iguana.prod.ib_hybrid_POC202001_5_v11` ;;
  label: "Consumerlink changed"
  description: "Refresh aggregate tables when consumerlink changes"
}

persist_with: orange_iguana_default_datagroup



map_layer: dma {
  file: "/dma_master_polygons_2_1.json"
  property_key: "dma_master_polygons_2_1"
}

explore: ib_hybrid_phu_test1 {}
