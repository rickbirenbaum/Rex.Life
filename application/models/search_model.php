<?php
class search_model extends CI_Model {
    public function __construct() {
        parent::__construct();
        $this->load->database();        
    }
    public function saveMySearch( $search, $user_id, $latitude, $longitude ) {        
             
       $result = $this->db->query("SELECT * FROM `search_histories` WHERE search_query = '" . $search . "'
                                   AND user_id =". $user_id . " LIMIT 1")->result();              
        
       if( !$result || !is_array( $result ) ) {
           
          $searchHistories = $this->db->query("SELECT id FROM search_histories WHERE user_id =". $user_id . " ORDER BY searched_on ASC")->result();              
         
          if( $searchHistories && count($searchHistories) > 5 ) {
             
             $count = count($searchHistories) -5;
             $this->db->query("DELETE FROM search_histories ORDER BY searched_on ASC LIMIT $count");                      
          }
          $save = $this->db->query("INSERT INTO search_histories (id, user_id, search_query,
                            latitude, longitude, searched_on)
                            VALUES ('',". $this->db->escape($user_id) .
                            "," . $this->db->escape($search) .   
                            "," . $this->db->escape($latitude) .  
                            "," . $this->db->escape($longitude) . 
                            ", '". date('Y-m-d h:i:s') ."')");
         
          if($save) {                 
                
                $response["status"] = "Success";
                $response["data"] = array("search_history_id" => mysql_insert_id(),
                                          "search_query" => $search, "message" => "Seach saved is successfull");
                               
          } else {                
                $response["status"] = "Failure";
                $response["error"] = array("errcode"=>"130", "errormsg"=>"  Unable to add place details.");
               
          }
          
          return json_encode($response); 
       }
        
    }
    public function getSearchHistory( $user_id ) {
        
       $result = $this->db->query("SELECT * FROM `search_histories` WHERE user_id =". $user_id . " ORDER BY searched_on DESC LIMIT 5")->result();              
        
      if( !$result || !is_array( $result ) ){
           // no data found
          $response["status"] = "Success";
          $response["data"] = array( "data" => array() );
       } else {
           $response["status"] = "Success";
           $response["data"] = array(
                                    "data" => $result );
       }
       return json_encode($response);
    }
}
?>