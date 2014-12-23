<?php
class syncfriends_model extends CI_Model {
    public function doSync( $session_id, $contacts ) {
       
       $arrayFriends = array();
       $arrayUsers = array();
       $userId = NULL;
       if(!$session_id){ 
           json_encode('Error: Please SignUp/SignIn');
           echo 'Error: Please SignUp/SignIn';
       }
       
       //$contacts = array('01234567890','01234567891','01234567892','01234567893','01234567894','01234567895');
       $result = $this->db->query("SELECT * FROM (`users`) WHERE `phone` IN (".implode(',',$contacts).")")->result();
       if( $result ) {
           foreach($result as $rowContact) {
               $arrayUsers[] = $rowContact->id;
            }
          
            $resultMyUser = $this->db->query("SELECT * FROM (`users`) WHERE `session_id` ='".$session_id."'")->result();
            if( $resultMyUser ) {
                foreach( $resultMyUser as $rowContact) {
                    $userId = $rowContact->id;
                }             
            } else {
                 json_encode('Error: Please SignUp/SignIn');
                 echo 'Error: Please SignUp/SignIn';
                 exit;
            }
                        
            $arrayFriendsToRemove = array();
            $resultFriends = $this->db->query("SELECT friends.friend_user_id FROM `friends` WHERE friend_user_id NOT IN(".implode(',',$arrayUsers).") AND friends.`user_id` =".$userId)->result();
            foreach($resultFriends as $row){               
                 $arrayFriendsToRemove[] = $row->friend_user_id;
            }

            $resultMyFriends = $this->db->query("SELECT friends.friend_user_id FROM `friends` WHERE friends.`user_id` =".$userId)->result();
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
               $query = "INSERT INTO friends(user_id,friend_user_id) VALUES (" . $this->db->escape($userId) . "," . $this->db->escape($friendToAdd) . ")";
               $isSaved = $this->db->query($query);                 
              // echo "One friend synced successfully.\n";
            }
            foreach($arrayFriendsToRemove as $friendToRemove ) {
                 $query = "DELETE FROM friends WHERE user_id =". $userId ." AND  friend_user_id=". $friendToRemove;
                 $isSaved = $this->db->query($query);
                // echo "One friend removed successfully.\n";
            }
             json_encode(count($arrayFriendsToAdd) . " Users synced successfully, and " . count($arrayFriendsToRemove) ." users removed successfully." );
             echo count($arrayFriendsToAdd) . " Users synced successfully, and " . count($arrayFriendsToRemove) ." users removed successfully." ;
                    
         } else {
             json_encode('Error: No records to sync');
             echo 'Error: No records to sync';
             exit;
         }
    }     
  }
?>