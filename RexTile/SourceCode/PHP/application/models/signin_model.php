<?php
class Signin_model extends CI_Model {
    
    public function doVerify($verCode,$session_id) {        
       $result = $this->db->query("SELECT * FROM `verification_codes` v JOIN users ON 
            users.id = v.user_id WHERE `users`.session_id='" . $session_id . "' LIMIT 1")->result();              
        
        foreach($result as $res) {
            if($res->verification_code == $verCode ) {
                $this->db->query("DELETE FROM `verification_codes` WHERE `verification_code`='" . $verCode . "'"); 
                $response["status"] = "Success";
                $response["data"] = array("session_id" => $session_id, "message" => "Your veriifcation is successfull");  
   
                return json_encode($response); 
                
            } else {   
                 $response["status"] = "Failure";
                 $response["error"] = array("errcode"=>"103", "errormsg"=>"Failed to verify code");

                 return json_encode($response);                
            }
        } 
    }
    
     public function signIn($phone, $sessionId) {
        $result= $this->db->query("UPDATE `users` SET `session_id` = '". $sessionId."' WHERE `users`.`phone` =".$this->db->escape($phone));
        if($result) {
            return $result;
        }
    }
}
?>