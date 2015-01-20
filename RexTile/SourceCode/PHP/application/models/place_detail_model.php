<?php
class place_detail_model extends CI_Model {
     public function __construct() {
        parent::__construct();
       
        $this->load->database();      
    }
    public function getPlaceDetails($user_id,$place_id) {  
       
      $strQuery =  "(SELECT count(pd.place_id) as count,pd.name as place_name,                                   
                rec.id as recId, NULL as try_id, rec.recommended_on as date, u.id as user_id
                  FROM place_details pd
                  JOIN recommendations rec
                       ON rec.place_detail_id = pd.id                                 
                  JOIN users u
                       ON u.id = rec.user_id
                 where u.id =".$user_id." AND
                 pd.place_id = '".$place_id."'
                 group by pd.place_id
                 ORDER BY date DESC)
             UNION ALL
           ( SELECT count(pd1.place_id) as place_id,pd1.name as place_name,                                      
                 NULL as recId,t.id as try_id, t.saved_on as rdate, us.id as user_id
                 FROM place_details pd1                                  
                  JOIN try_list t
                       ON pd1.id = t.place_detail_id                                  
                  JOIN users us
                       ON us.id = t.user_id
                   WHERE us.id =".$user_id." 
                       AND 
                   pd1.place_id = '".$place_id."'
                   GROUP BY pd1.place_id                                        
                   ORDER BY rdate DESC
             )";
     
       $result = $this->db->query($strQuery)->result();     
       
       if($result || is_array($result)) {
           $response["status"] = "Success";
          foreach($result as $key=>$place) {
                if( $place->recId && NULL != $place->recId ){
                    // if its a recommondation
                    $data["type"] = 1;
                    $data["count"] = $place->count;
                    $data["place_id"] = $place_id;
                                     
                    $data["place_name"] = $place->place_name; 
                 
                    
                } else if( $place->try_id && NULL != $place->try_id ) {
                    // if a try list    
                    $data["type"] = 2;
                    $data["count"] = $place->count;
                    $data["place_id"] = $place_id;                                     
                    $data["place_name"] = $place->place_name; 
                }
                $response["recs"][$key] = $data; 
                $data = NULL;
            }
            $response = json_encode($response);
            print_r($response);
            return;
         
       } else {
            $response["status"] = "Failure";
            $response["error"] = array("errcode"=>"101", "errormsg"=>"New place");
            $response = json_encode($response);
             print_r($response);
            return;
       }
    }    
    
}
?>