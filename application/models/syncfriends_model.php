<?php
class syncfriends_model extends CI_Model {
    public function __construct() {
        parent::__construct();
        $this->load->database();        
    }
    public function doSync( $user_id, $session_id, $contacts ) {
       
       $arrayFriends = array();
       $arrayUsers = array();
       $listOfFriendUsers = $this->getListOfFriendUsers($contacts);
       
       if( $listOfFriendUsers ) {
           foreach($listOfFriendUsers as $rowContact) {
               $arrayUsers[] = $rowContact->id;
            }
                                  
            $arrayFriendsToRemove = array();
            
            $resultFriends = $this->db->query("SELECT friends.friend_user_id FROM `friends` WHERE friend_user_id NOT IN(".implode(',',$arrayUsers).") AND friends.`user_id` =".$user_id)->result();
            foreach($resultFriends as $row){               
                 $arrayFriendsToRemove[] = $row->friend_user_id;
            }

            $resultMyFriends = $this->db->query("SELECT friends.friend_user_id FROM `friends` WHERE friends.`user_id` =".$user_id)->result();
            if($resultMyFriends) {
                foreach($resultMyFriends as $row){               
                    $arrayFriends[] = $row->friend_user_id;
                }
                if($arrayFriends) {
                    $arrayFriendsToAdd = array_diff($arrayUsers,$arrayFriends);
                }
            } else {
                $arrayFriendsToAdd = $arrayUsers;
            }
            foreach($arrayFriendsToAdd as $friendToAdd ) {
               $query = "INSERT INTO friends(user_id,friend_user_id) VALUES (" . $this->db->escape($user_id) . "," . $this->db->escape($friendToAdd) . ")";
               $isSaved = $this->db->query($query);                 
              // echo "One friend synced successfully.\n";
            }
            foreach($arrayFriendsToRemove as $friendToRemove ) {
                 $query = "DELETE FROM friends WHERE user_id =". $user_id ." AND  friend_user_id=". $friendToRemove;
                 $isSaved = $this->db->query($query);
                // echo "One friend removed successfully.\n";
            }
             $response["status"] = "Success";
             $response["data"] = array("session_id"=>$session_id,"user_id"=>$user_id,
                                        "count_add"=>count($arrayFriendsToAdd),
                                        "count_removed"=>count($arrayFriendsToRemove));
             
             return json_encode($response);
                    
         } else {
            $response["status"] = "Success";
            $response["error"] = array("errcode"=>"104", "errormsg"=>" No records to sync");
            return json_encode($response);             
         }
    }
    
     public function highlightFriends( $user_id, $session_id,$contacts ){
               
        $response = $listOfFriendUsers = $this->getListOfFriendUsers( $contacts, $is_highlight = true );
               
        return $response;
    }
    
    public function getListOfFriendUsers( $contacts, $is_highlight = false ) {
       $contact1 = array();
       foreach( $contacts as $contact ) {
            $contact1[] = preg_replace('/[^0-9]/', '', $contact);           
       }
       $contact1 = array_filter($contact1);
       
       //$contacts = array('01234567890','01234567891','01234567892','01234567893','01234567894','01234567895');
       $result = $this->db->query("SELECT id,phone FROM (`users`) WHERE `phone` IN (".implode(',',$contact1).")")->result();
      
       if( true == $is_highlight ) {
           // get call for highlight API
           $response["status"] = "Success";
           if(!empty($result)) {
                $response["data"] = $result;
                
           } else {
               $response["data"] = NULL;
           } 
           $response = json_encode($response);
           
           print_r($response);
           return true;
           
       } else { // simple get call
        return $result;
       }      
    }
    
  }
?>