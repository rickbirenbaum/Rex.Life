<?php
class settings_model extends CI_Model {
    public function __construct() {
        parent::__construct();      
    }
    public function showSettings( $session_id, $user_id ) {
        
        $this->load->model('recommendation_model');
        
        $verifiedSession = $this->recommendation_model->getUserId( $session_id, $user_id );
            // check for the session
        if(!$verifiedSession) {        
           return false;
        }
     
        $queryMyUser = $this->db->query( "SELECT * from users u WHERE u.id = " . $user_id ." LIMIT 1" )->result();
        
        $queryMyUser = $queryMyUser[0];
        if( $queryMyUser ) {
            $response["status"] = "Success"; 
            $response["user_id"] = $user_id;    
            $response["session_id"] = $session_id; 
            $response["phone"] = $queryMyUser->phone;
            $response["name"] = $queryMyUser->name;
            $response["email"] = $queryMyUser->email_id;
            $response = json_encode($response);
            
            return $response;
        } else {
            $response["status"] = "Failure";
            $response["error"] = array("errcode"=>"101", "errormsg"=>"No user found");
            $response = json_encode($response);
            
            return $response;
        }
        
    }     
}
?>