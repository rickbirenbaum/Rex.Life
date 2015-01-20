<?php
class activities_model extends CI_Model {
    public function __construct() {
        parent::__construct();
        $this->load->helper('form');
    }
    public function showMyActivities( $session_id, $user_id ) {
        $this->load->model('recommendation_model');
        
        $verifiedSession = $this->recommendation_model->getUserId( $session_id, $user_id );
            // check for the session
        if(!$verifiedSession) {
           $response["status"] = "Failure";
           $response["error"] = array("errcode"=>"101", "errormsg"=>"Please login");
           $response = json_encode($response);            
           return $response;
        }
     
        $queryMyFriends = $this->db->query( "SELECT f.friend_user_id as user_id FROM `friends` f 
                              JOIN users u ON 
                              u.id= f.user_id
                            WHERE u.id = " . $user_id )->result();
        $arrUserIds[0] = $user_id;
        foreach($queryMyFriends as $row) {
           $arrUserIds[] =$row->user_id;
        }       
        
        $arrCats = $this->db->query("SELECT id,name from place_categories")->result(); 
         $arrAllCategories = array();
         $category_ids = NULL;
         foreach($arrCats as $cats){
             $arrAllCategories[$cats->id] = $cats->name;
         }
         
        $queryRecentActivities = $this->db->query("
                    SELECT * FROM 
                        ( (SELECT 
                                u.id as user_id, u.phone, NULL AS place_detail_id, u.name,
                                u.email_id, u.created_date as created,
                               
                                NULL as category_id,
                                NULL as place_name,NULL as place_id, NULL as  photos,
                                NULL as latitude, NULL as longitude,
                                NULL as international_phone, NULL as rating, 
                                NULL as address, NULL as recommendation_count
                           FROM users u ) 
                           UNION ALL
                          (SELECT r.user_id AS user_id, us.phone, r.place_detail_id,
                                NULL AS name, NULL AS email_id, r.recommended_on as created,
                        	
                                p.category_id as category_id,
                                p.name as place_name,p.place_id,p.photos, p.latitude, 
                                p.longitude,p.international_phone, p.rating, p.address,
                          ( select count(*) from recommendations recs WHERE recs.place_detail_id = p.id) as recommendation_count
                            FROM recommendations r, place_details p, users us
                           WHERE
                           p.id = r.place_detail_id 
                           
                            AND us.id = r.user_id
                            ) ) result
                    WHERE user_id IN (".implode(',',$arrUserIds).") 
                    ORDER BY created DESC
                    LIMIT 10") -> result();

        if( $queryRecentActivities ) {
            
            foreach( $queryRecentActivities as $resultMyTry ) {
            
                foreach( explode(',',$resultMyTry->category_id) as $cat_id ) {
                    if($cat_id){
                        $category_ids .= $arrAllCategories[$cat_id] . ',';
                    }
                }
                 $resultMyTry->category_id = substr($category_ids, 0, -1);
                 $category_ids = NULL;
            }
            $response["status"] = "Success"; 
            $response["user_id"] = $user_id;    
            $response["session_id"] = $session_id;    
            foreach($queryRecentActivities as $key => $recentActivity) {
                if( $recentActivity->place_detail_id ){
                    // if its a recommondation
                    $data["type"] = 2;
                    $data["recommendation_count"] = $recentActivity->recommendation_count;
                    $data["user_id"] = $recentActivity->user_id;
                    $data["message"] = $recentActivity->phone  . " recommended place";
                    $data["date"] = $recentActivity->created;
                    $data["phone"] = $recentActivity->phone;
                    $data["category_name"] = $recentActivity->category_id;                    
                    $data["place_name"] = $recentActivity->place_name; 
                    $data["address"] = $recentActivity->address;      
                    $data["place_id"] = $recentActivity->place_id;
                    $data["latitude"] = $recentActivity->latitude;
                    $data["longitude"] = $recentActivity->longitude;
                    $data["rating"] = $recentActivity->rating;                                         
                    $data["international_phone"] = $recentActivity->international_phone;                    
                    
                } else {
                    // if a user joining     
                    $data["type"] = 1;
                    $data["message"] = $recentActivity->phone  . " has joined Rextile";
                    $data["user_id"] = $recentActivity->user_id;
                    $data["date"] = $recentActivity->created;
                }
                $response["activities"][$key] = $data; 
                $data = NULL;
            }
            $response = json_encode($response);
            
            return $response;
        } else {
            $response["status"] = "Failure";
            $response["error"] = array("errcode"=>"101", "errormsg"=>"No activities");
            $response = json_encode($response);
            
            return $response;
        }
        
    }     
}
?>