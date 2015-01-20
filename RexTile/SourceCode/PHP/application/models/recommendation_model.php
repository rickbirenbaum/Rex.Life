<?php
class recommendation_model extends CI_Model {
    public function __construct() {
        parent::__construct();
        define('MY_ALL_FRIENDS_RECS',0);
        define('MY_RECS',1);       
        define('MY_FRIEND_RECS',2);
        
        $this->load->database();
        $this->load->helper('form');
    }
    
    public function addRecommendation() {
               
        $session_id= $this->input->post('session_id');
        $user_id= $this->input->post('user_id');
        
        $date = date('Y-m-d h:i:s');
        
        $name = $this->input->post('place_name');
        $place_id = $this->input->post('place_id');
        
        $latitude = $this->input->post('latitude');
        $longitude = $this->input->post('longitude');
        $photos =  $this->input->post('photos');
        $international_phone = $this->input->post('international_phone');
        $rating =$this->input->post('rating');
        $address = $this->input->post('address');
        
        // check whether it is try list entry
        $is_try = $this->input->post('is_try');
        if( $is_try && $is_try == 1 ){
            $tableName = " try_list";  
            
        }else {
           $tableName = " recommendations";            
        }
        $arrCat = explode( ',', $this->input->post('categories') );
        //$category_name = $arrCat[0];
        
        $verifiedSession = $this->getUserId( $session_id, $user_id );
        
        if(!$verifiedSession) {
            return false;
        }
        // check for place category
       
        if( $arrCat || is_array($arrCat) ) {
            
            foreach( $arrCat as $cat ) {
                if($cat) {
                    $this->db->query("
                            INSERT INTO place_categories (name)
                            SELECT * FROM (SELECT " . $this->db->escape($cat) . ") AS tmp
                            WHERE NOT EXISTS (
                                SELECT name FROM place_categories WHERE name = " . $this->db->escape($cat) .
                            ") LIMIT 1");

                    $intPlaceCategoryIds[$cat] = mysql_insert_id();
                }
            }
                   
            foreach($intPlaceCategoryIds as $cat_name => $intPlaceCategoryId ) {
                if($intPlaceCategoryId == 0 ) {
                    $res = $this->db->query("SELECT id from place_categories WHERE name = '".$cat_name ."' LIMIT 1")->result();
                    $intPlaceCategoryIds[$cat_name] = $res[0]->id;
                }
                
            }
            // implode by ',' all category ids
            $intPlaceCategoryIds = implode(',',$intPlaceCategoryIds);
            
        }
        
        //check for place_detail        
         $isPlaceSaved = $this->db->query("SELECT id FROM `place_details` 
                                           WHERE `place_id` LIKE '" . $place_id . "' LIMIT 1")->result();
        
         if( !$isPlaceSaved || false == is_array($isPlaceSaved) ) {
            
             $result = $this->db->query("INSERT INTO `place_details` (`id`, `name`, `place_id`, `category_id`, 
                                        `latitude`, `longitude`, `photos`, `international_phone`, `rating`, `address`) 
                                         VALUES ('',".$this->db->escape($name).
                                         "," . $this->db->escape($place_id) .
                                         "," . $this->db->escape($intPlaceCategoryIds) .
                                         "," . $this->db->escape($latitude) .
                                         ",". $this->db->escape($longitude).
                                         ",". $this->db->escape($photos).
                                         ",". $this->db->escape($international_phone) .
                                         ",".$this->db->escape($rating).
                                         ",". $this->db->escape($address) . ")");
           
            if($result) {                 
                $place_detail_id = mysql_insert_id();
            } else {
                
                $response["status"] = "Failure";
                $response["error"] = array("errcode"=>"104", "errormsg"=>"  Unable to add place details.");
                $response =  json_encode($response);
                
                return $response;                   
            }
        } else {
            foreach($isPlaceSaved as $place) {
                $place_detail_id = $place->id;
            }
        }                
        
        //insert recommendation
        $response = $this->insertRecommendation($tableName,$user_id,$name,$place_id,$place_detail_id,$date);                
        return $response;
    }
     
    public function getRecommendations() {
         
         $user_id= $this->input->post('user_id');
         $session_id= $this->input->post('session_id');
         $typeRecommendation = $this->input->post('type');
         
         if( MY_RECS == $typeRecommendation ) {
            // request for my recommondations
            $verifiedSession = $this->getUserId( $session_id, $user_id );        
            // check for the session
            if(!$verifiedSession) {
                return false;
            }
            $strQuery = " WHERE u.id = r.user_id 
                         AND r.user_id = ". $user_id . " ";
            
         } else if ( MY_ALL_FRIENDS_RECS == $typeRecommendation ) {
             // request for my friends recommondations             
             $strQuery = " ,friends f
                            WHERE
                             f.friend_user_id = r.user_id                 
                           AND u.id = f.friend_user_id 
                           AND f.user_id = " . $user_id . " ";
             
         } else if( MY_FRIEND_RECS == $typeRecommendation ) {
             // specific friends recommondations
             $friend_user_id= $this->input->post('friend_user_id');
             if(!$friend_user_id){
                $response["status"] = "Failure";
                $response["error"] = array("errcode"=>"112", "errormsg"=>"Enter valid friend contact");
                $response =  json_encode($response);
                return $response;
             }
             $strQuery = " WHERE u.id = r.user_id 
                          AND r.user_id = ". $friend_user_id . " ";
         }
         
         $arrCats = $this->getCategories();        
         $arrAllCategories = array();
         $category_ids = NULL;
         foreach($arrCats as $cats){
             $arrAllCategories[$cats->id] = $cats->name;
         }
         $strQueryRecs = "SELECT distinct(p.id),p.place_id,r.id as rec_id,
                                 p.name, p.category_id as category_id, p.address,
                                p.international_phone, p.rating, p.latitude,p.longitude,
                               (SELECT count(*) as count1 FROM recommendations rec WHERE rec.place_detail_id = p.id) as recommendation_count
                          FROM recommendations r 
                            ,place_details p                           
                            ,users u " .                           
                          $strQuery . " 
                          AND r.place_detail_id = p.id
                          ORDER BY r.recommended_on DESC";
         
    $strQueryRecs = "SELECT distinct(p.place_id),r.id as rec_id, p.place_id,
                                 p.name, p.category_id as category_id, p.address,
                                p.international_phone, p.rating, p.latitude,p.longitude,
                               (SELECT count(*) as count1 FROM recommendations rec WHERE rec.place_detail_id = p.id) as recommendation_count
                          FROM recommendations r  ,place_details p                           
                            ,users u " .                           
                          $strQuery . " 
                              AND r.place_detail_id = p.id
                          ORDER BY r.recommended_on DESC ";
    
     $strQueryRecs = "select distinct (temp.place_id),temp.* from (SELECT r.id as rec_id, p.place_id,
                                 p.name, p.category_id as category_id, p.address,
                                p.international_phone, p.rating, p.latitude,p.longitude,
                              (SELECT count(*) as count1 FROM recommendations rec WHERE rec.place_detail_id = p.id) as recommendation_count
                          FROM recommendations r  ,place_details p                           
                            ,users u " .                           
                          $strQuery . " 
                              AND r.place_detail_id = p.id
                          ORDER BY r.recommended_on DESC )as temp";     
     
         $resultMyRecommendations = $this->db->query($strQueryRecs)->result();
         $resultMyRecommendations1 =array();
         foreach( $resultMyRecommendations as $resultMyRec ) {
            
            foreach( explode(',',$resultMyRec->category_id) as $cat_id ) {
                if(array_key_exists($cat_id, $arrAllCategories)) {
                    $category_ids .= $arrAllCategories[$cat_id] . ',';
                }
            }
             $resultMyRec->category_id = substr($category_ids, 0, -1);
             $resultMyRecommendations1[$resultMyRec->place_id] = $resultMyRec;
             $category_ids = NULL;
         }
         if($resultMyRecommendations1 && is_array( $resultMyRecommendations1 ) ) {
             $response["status"] ="Success";
             $response["data"] = array( "recs" => array_values( $resultMyRecommendations1 ) );
            return json_encode($response);
         } else {
             // no data found
             $response["status"] = "Success";
             $response["data"] = array("recs"=>array());
             $response =  json_encode($response);
             return $response;
         }
        
    }  
     
    public function getRecommendationCounts() {
        $user_id= $this->input->post('user_id');
        $session_id= $this->input->post('session_id');
        
        $verifiedSession = $this->getUserId( $session_id, $user_id );        
            // check for the session
         if(!$verifiedSession) {
                return false;
         }
        
         $arrMyRecs = $this->db->query( "SELECT count(distinct(p.id)) as count FROM recommendations r,place_details p                                        
                                         WHERE r.place_detail_id = p.id AND user_id = " . $user_id . 
                                         " UNION ALL 
                                          SELECT count(distinct(p.id)) as count FROM recommendations r,place_details p                                        
                                            WHERE r.place_detail_id = p.id AND user_id IN ( SELECT friend_user_id FROM friends 
                                                             WHERE user_id = " . $user_id . ")" )->result();
         
        $response["status"] ="Success";
         if(is_array($arrMyRecs)) {
            
            /*$response["data"] = array("session_id" => $session_id,                                                                            
                                       "user_id"   => $user_id);*/
            $response["data"]["my_recs"] = $arrMyRecs[0]->count;
            $response["data"]["my_friend_recs"] = $arrMyRecs[1]->count;
            
             $response =  json_encode($response);
             return $response;
         } else {           
             $response["data"]["my_recs"] = 0;
             $response["data"]["my_friend_recs"] = 0;
             $response =  json_encode($response);
             return $response;
         }
         
    }
    
    public function getTryList(){
         $user_id= $this->input->post('user_id');
         $session_id= $this->input->post('session_id');
         
         $verifiedSession = $this->getUserId( $session_id, $user_id );        
         
         // check for the session
         if(!$verifiedSession) {
                return false;
         }
         $arrCats = $this->getCategories();  
        
         $arrAllCategories = array();
         $category_ids = NULL;
         foreach($arrCats as $cats){
             $arrAllCategories[$cats->id] = $cats->name;
         }
         $strQueryList = "SELECT t.id as try_list_id, t.user_id as try_list_user_id, 
                                u.phone as user_phone, u.name user_name, p.place_id,p.category_id,
                                p.address, p.international_phone, p.rating, t.saved_on 
                          FROM try_list t 
                          JOIN place_details p 
                              ON t.place_detail_id = p.id                           
                          JOIN users u 
                                ON u.id = t.user_id 
                          WHERE t.user_id = ". $user_id . "
                          ORDER BY t.saved_on DESC";
        echo $strQueryList;die;
         $resultMyTryList = $this->db->query($strQueryList)->result();
         
         foreach( $resultMyTryList as $resultMyTry ) {
            
            foreach( explode(',',$resultMyTry->category_id) as $cat_id ) {
                $category_ids .= $arrAllCategories[$cat_id] . ',';
            }
             $resultMyTry->category_id = substr($category_ids, 0, -1);
             $category_ids = NULL;
         }
     
         if($resultMyTryList && is_array( $resultMyTryList ) ) {
             $response["status"] ="Success";
             $response["data"] = array( "count" => count($resultMyTryList),                                                                             
                                        "try_list" => $resultMyTryList );
             $response =  json_encode($response);
             print_r($response);             
         } else {
             // no data found
             $response["status"] = "Success";
             $response["data"] = array("count"=>0,"try_list"=>array());
             $response =  json_encode($response);
             return $response;
         }
    }
     
    public function removeRecommendations($sessionId, $inputUserId, $place_Id ) {
       $verifiedSession = $this->getUserId( $sessionId, $inputUserId );        
            // check for the session
         if(!$verifiedSession) {
                return false;
         }
       // check whether it is try list entry
        $is_try = $this->input->post('is_try');
        
        if( $is_try && $is_try == 1 ){
            $tableName = " try_list";  
            
        }else {
           $tableName = " recommendations";            
        }
       
        $strQuery = $this->db->query("SELECT *, r.id as recId FROM `place_details` pd join ".$tableName." r
                                      ON pd.id = r.place_detail_id
                                      WHERE pd.place_id = '".$place_Id."'
                                        AND r.user_id =".$inputUserId ." LIMIT 1")->result();                      
        
        $recId = NULL;
        if( count( $strQuery )> 0 ) {
            $strRecs = $strQuery[0];
            $recId = $strRecs->recId; 
            $intPlaceDetailId = NULL;
            foreach( $strQuery as $placeId ) {
                $intPlaceDetailId = $placeId->place_detail_id;
            }
            
            $isPlaceRecommendedByOthers = $this->db->query( 
                            " SELECT count(*) as count FROM ( 
                                ( SELECT * from recommendations r 
                                 WHERE r.place_detail_id =". $intPlaceDetailId . " )	 
                              UNION ALL
                                 ( SELECT * from try_list t
                                  WHERE t.place_detail_id  = ". $intPlaceDetailId . " )

                               ) result")->result();


             if( $isPlaceRecommendedByOthers[0]->count <= 1 ) {

                 $this->db->query("DELETE FROM place_details   
                                            WHERE id= ".$strQuery[0]->place_detail_id. " LIMIT 1");                
             } // if isPlaceRec ends here
        } // if place_detail count > 1 ends 
        else {
           // no records with given id found
        }
         if($recId) {
            $queryResult = $this->db->query( "DELETE FROM " . $tableName . 
                                              " WHERE id = " . $recId);;
             if( !$queryResult ) {

                 $response["status"] = "Failure";
                 $response["error"] = array("errcode"=>"101", "errormsg"=>"No such recommedation/try list found");
                 $response =  json_encode($response);            
                 return $response;       
             }        
             $response["status"] = "Success";
             $response["data"] = array(
                                       "id"        => $recId,
                                       "message"   => $tableName . " entry deleted successfully.");
             $response =  json_encode($response);        
             return $response;
         } else {
               $response["status"] = "Failure";
               $response["error"] = array("errcode"=>"101", "errormsg"=>"No such recommedation or try list found");
               $response =  json_encode($response);            
               return $response;       
         }
    }
     
    public function moveTryListPlaceToRecommendation( $session_id,$user_id, $placeid) {
        $verifiedSession = $this->getUserId( $session_id, $user_id );        
         
         // check for the session
         if(!$verifiedSession) {
                return false;
         }
         $date = date('Y-m-d h:i:s');
        
         $objTryListPlace = $this->db->query( "SELECT 
                       t.id as try_id, pd.name as place_name,t.place_detail_id
                       FROM try_list t                                        
                       JOIN  place_details pd
                         ON pd.id = t.place_detail_id
                       JOIN users u 
                          ON u.id = t.user_id 
                       WHERE pd.place_id ='" .  $placeid . "' AND u.id =". $user_id." LIMIT 1" )->result();         
         
         if(is_array($objTryListPlace)) {
             
            foreach( $objTryListPlace as $objTryPlace ) {
                // move to recommendations
                 $response = $this->insertRecommendation( $tableName = "recommendations", $user_id, $objTryPlace->place_name,
                                            $placeid, $objTryPlace->place_detail_id, $date, $moveTryListId = $objTryPlace->try_id );
                 print_r($response);                  
            }
         } else {
             $response["status"] = "Failure";
             $response["error"] = array("errcode"=>"101", "errormsg"=>"No such try list entry found");
             $response =  json_encode($response);            
             print_r($response);
             return $response; 
         }
    }
    
    
    public function getUserId($sessionId, $inputUserId ) {
         $queryResult = $this->db->query( "SELECT * FROM (`users`) 
                                           WHERE `session_id`='" . $sessionId ."'
                                           AND id = ".$inputUserId."
                                          LIMIT 1")->result();  
      
         if( count($queryResult)<=0 && empty($queryResult) ) {         
             $response["status"] = "Failure";
             $response["error"] = array("errcode"=>"110", "errormsg"=>"Please login once again ");
             $response =  json_encode($response);
             print_r($response);
             return false;       
        } else {
            return true;
        }
    }
    
    public function insertRecommendation($tableName,$user_id,$name,$place_id,$place_detail_id,$date,$moveTryListId=NULl) {
        
        //check for recommendation
         $isPlaceRecommended = $this->db->query("SELECT id FROM ". $tableName . 
                                                " WHERE user_id =" . $user_id . "
                                                AND place_detail_id =" . $place_detail_id . "
                                                LIMIT 1")->result();
         
         if( !$isPlaceRecommended || false == is_array($isPlaceRecommended) ) {
            $result = $this->db->query("INSERT INTO ". $tableName . 
                                           " 
                                          VALUES (''," .  $this->db->escape($user_id). 
                                          "," . $this->db->escape( $place_detail_id ).
                                          "," . $this->db->escape($date). ")");

                if($result){                
                    if($moveTryListId) {
                        $insertedRecId = mysql_insert_id();
                        $is_deleted = $this->db->query( "DELETE FROM  try_list
                                     WHERE id = " . $moveTryListId );
                        if(!$is_deleted) {
                            $this->db->query( "DELETE FROM  recommendations
                                       WHERE id = " . $insertedRecId );
                            $response["status"] = "Failure";
                            $response["error"] = array("errcode"=>"104", "errormsg"=>"Unable to move recommendation" );

                            $response =  json_encode($response);
                            return $response;  
                        }
                        
                    }
                     $response["status"] = "Success";
                     $response["data"] = array("message" => $name ." saved to " . $tableName 
                                                   . " successfully.");  
                   $response =  json_encode($response);

                    return $response;              
                } else {

                    $response["status"] = "Failure";
                    $response["error"] = array("errcode"=>"104", "errormsg"=>"Unable to save " . $tableName );

                    $response =  json_encode($response);

                    return $response;  
              }
         }  else {
            
            $response["status"] = "Failure";
            $response["error"] = array("errcode"=>"111", "errormsg"=>"You have already saved this place to " . $tableName);
            $response =  json_encode($response);
                            
            return $response;  
         }  
    }
    public function getAllCategories() {
        $arrCat = $this->getCategories( $showId = false );
        $response["status"] = "Success";
        $response["data"] = $arrCat;
        $response = json_encode($response);
       
        print_r($response);
        return true;
    }
    public function getCategories($showId = true) {
        if($showId){
            $strQuery = "id, name";
        } else {
            $strQuery = "name";
        }
        $arrCat = $this->db->query("SELECT " . $strQuery . " FROM place_categories")->result();
        return $arrCat;
    }
    
    public function getRecommendationsByPlaceIds($place_ids, $user_id) {
        
        $response["status"] ="Success";
        if( !is_array($place_ids ) ) {
           
            $response["data"] = NULL;
            
            $response = json_encode($response);
            print_r( $response );          
                        
        } else {            
             $recs = $this->db->query("SELECT DISTINCT(place_id) FROM place_details p 
                              JOIN recommendations r ON r.place_detail_id = p.id 
                                                  
                              WHERE place_id IN(" .implode(',', $place_ids ) . ") AND r.user_id =". $user_id)->result();
            
            if(!empty($recs) && count($recs)>0) {
                $recs1 ="";
                foreach ($recs as $rec){
                    $recs1 .= $rec->place_id . ',';
                }
                //$response["data"] = "(".substr($recs1,0,-1) .")";
                 $response["data"] = $recs;
            } else {
                $response["data"] = $recs;
            }                      
            
            $response = json_encode($response);
            print_r( $response );
            return true;
        }
    }
    
    public function sendRecommendationSmsToUsers( $user_id,$contacts,$place_id ){
        $place_detail = $this->db->query(" SELECT p.id,p.name as place_name,u.name as name, u.phone as phone FROM place_details p
                                            JOIN recommendation r 
                                                ON r.place_detail_id = p.id 
                                            JOIN uesrs u
                                                ON u.id = r.user_id
                                            WHERE p.place_id ='".$place_id ."' AND r.user_id =" . $user_id )->result();
        if(!is_array($place_detail)|| empty($place_detail)) {
            $response["status"] = "Failure";
            $response["error"] = array("errcode"=>"101", "errormsg"=>"Unable to find Recommendation ");
            print_r(json_encode($response));
            return false;
        }
        $place_detail = $place_detail[0];
        
        $user = "rickbirenbaum";
        $password = "TYDaPQZbGPJGCK";
        $api_id = "3515803";
        $baseurl ="http://api.clickatell.com";
        
        $response = array();
        
        foreach( $contacts as $key=>$contact ) {
        
            $text = urlencode("Your friend " . $place_detail->name ."(".$place_detail->phone.") has recommended " . $place_detail->place_name . ". Thanks");
           

            // auth call
            $url = "$baseurl/http/auth?user=$user&password=$password&api_id=$api_id";

            // do auth call
            $ret = file($url);

            // explode our response. return string is on first line of the data returned
            $sess = explode(":",$ret[0]);
            if ($sess[0] == "OK") {

                $sess_id = trim($sess[1]); // remove any whitespace
                $url = "$baseurl/http/sendmsg?session_id=$sess_id&to=$contact&text=$text";

                // do sendmsg call
                $ret = file($url);

                $send = explode(":",$ret[0]);

               // if ($send[0] == "ID") {
                    $response[$key]["status"] = "Success";
                    $response[$key]["data"] = array("sms_status" => trim($send[1]), "phone" =>$contact);                                       

               /* } else {
                    json_encode("Error: Sending message failed");
                }*/
            } else {
                $response[$key]["status"] = "Failure";
                $response[$key]["error"] = array("errcode"=>"102", "errormsg"=>"Authentication failure:".$ret[0]);
                
            }  
        }
      
        print_r(json_encode($response));
        return;
    }
  
    public function getRecommendationsCountByPlaceIds($place_ids) {
        
        if( count($place_ids) && $place_ids) {
            $response["status"] ="Success";
            foreach($place_ids as $key=>$place_id) {              
                $resultCount = $this->db->query("SELECT count(*) as count_rec, p.place_id
                            FROM `recommendations` r, place_details p 
                            WHERE r.place_detail_id = p.id
                            AND p.place_id =".$place_id ." LIMIT 1")->result();
                               
                if($resultCount) {
                    $response[$key]["data"] = array("place_id" => $place_id, "count"=> $resultCount[0]->count_rec);
                }
                
            }
            print_r(json_encode($response));
            return true;
        }        
    }
}
?>