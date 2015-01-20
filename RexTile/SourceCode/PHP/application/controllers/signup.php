<?php
class signup extends CI_Controller {
    public function __construct() {
        
        parent::__construct();         
        
        session_start();
        session_regenerate_id();
        $this->load->helper('form');
    }
    
    public function register(){        
        
        $phone= $this->input->post('phone'); 
        
        if(!$phone || 0 == $phone ) {
            $response["status"] = "Failure";
            $response["error"] = array("errcode"=>"112", "errormsg"=>"Please provide valid phone number");
            $response =  json_encode($response);
print_r($response);
            return $response;
        }
        $strLoginType = ''; 
        $this->load->model("signup_model");
        $this->data =  $this->signup_model->getSignUpDetails($phone);
      
        if($this->data){                  
            // do login by and set session
            $_SESSION['user_id'] = $this->data["user_id"];
            $_SESSION['phone'] = $this->data["phone"];
            
            $this->load->model("signin_model");
            $save =  $this->signin_model->signIn( $phone, session_id() ); 
            if( $save ){
                $strLoginType = 'sign in';                
                $result = $this->sendSms( $phone, $strLoginType );               
 print_r($result);
                return $result;
            }
                      
        } else {
            // save signUp
           $save =  $this->signup_model->saveSignUp( $phone, session_id() );
           if($save){                                                          
                $strLoginType = 'sign up';
                $_SESSION['user_id'] = $save["user_id"];
                $_SESSION['phone'] = $save["phone"];
               
                // Send sms tor $toSms number
                $result = $this->sendSms( $phone, $strLoginType );                
 print_r($result);
                return $result;
           }        
        } 
    }   
    
    public function sendSms( $phone, $strLoginType ) {
        
        $user = "rickbirenbaum";
        $password = "TYDaPQZbGPJGCK";
        $api_id = "3515803";
        $baseurl ="http://api.clickatell.com";
        
        $varificationCode = $this->randomString();
        
        $text = urlencode("You have successfully ".$strLoginType.", Please reply with the verification code " . $varificationCode . " Thanks");
        $to = $phone;

        // auth call
        $url = "$baseurl/http/auth?user=$user&password=$password&api_id=$api_id";

        // do auth call
        $ret = file($url);

        // explode our response. return string is on first line of the data returned
        $sess = explode(":",$ret[0]);
        if ($sess[0] == "OK") {

            $sess_id = trim($sess[1]); // remove any whitespace
            $url = "$baseurl/http/sendmsg?session_id=$sess_id&to=$to&text=$text";

            // do sendmsg call
            $ret = file($url);

            $send = explode(":",$ret[0]);

           // if ($send[0] == "ID") {               
                
                $query = $this->db->query("SELECT * FROM (`verification_codes`) WHERE `user_id`=" . $_SESSION['user_id']);              
                $result = $query->result(); 
                if(!$result) {
                    $this->db->query("INSERT INTO `verification_codes` (`id`, `user_id`, `verification_code`) 
                            VALUES ('',". $this->db->escape($_SESSION['user_id']).", '". $varificationCode . "')");
                } else {
                    $result= $this->db->query("UPDATE `verification_codes` SET `verification_code` = '". $varificationCode."' WHERE user_id =".$this->db->escape($_SESSION['user_id']));                    
                }
                              
                $response["status"] = "Success";
                $response["data"] = array("type"=>$strLoginType,"user_id"=>$_SESSION['user_id'],"session_id" => session_id(), "sms_status" => trim($send[1]), "phone" =>$phone);  
                
                return json_encode($response);                                
               
           /* } else {
                json_encode("Error: Sending message failed");
            }*/
        } else {
            $response["status"] = "Failure";
            $response["error"] = array("errcode"=>"102", "errormsg"=>"Authentication failure:".$ret[0]);
            return json_encode($response);            
        }        
    }
    
    public function sync() {
        $session_id= $this->input->post( 'session_id' );
        $user_id= $this->input->post( 'user_id' ); 
         
        // check for the session
        $this->load->model('recommendation_model');
        $verifiedSession = $this->recommendation_model->getUserId( $session_id, $user_id );
       
        if(!$verifiedSession) {
            return false;
        }
        $contacts = explode( ',', $this->input->post( 'contacts' ) );
        if( !is_array($contacts ) ) {
            $response["status"] = "Failure";
            $response["error"] = array("errcode"=>"101", "errormsg"=>"No contact to sync");
            
            $response = json_encode($response);
            print_r( $response );                
            
            exit;
        }
        $this->load->model( "syncfriends_model" );
        $response =  $this->syncfriends_model->doSync( $user_id, $session_id,$contacts );
print_r($response);
        return $response;
    }
    
    public function randomString() {
        $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $randstring = '';
        for ( $i = 0; $i < 6; $i++ ) {
            $randstring .= $characters[rand( 0, strlen( $characters )-5 )];
        }
        return $randstring;
    }
    
}
?>