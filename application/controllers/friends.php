<?php
class friends extends CI_Controller {
    public function __construct() {
        parent::__construct();
        $this->load->helper('form');
    }
    
    public function index(){
       
        $session_id = $this->input->post("session_id");
        $user_id = $this->input->post("user_id");
        
        $this->load->model('recommendation_model');
        $verifiedSession = $this->recommendation_model->getUserId( $session_id, $user_id );
      
        if(!$verifiedSession) {
            return false;
        }
        $contacts = explode( ',', $this->input->post( 'contacts' ) );
        if( !$contacts || !is_array($contacts ) ) {
            $response["status"] = "Failure";
            $response["data"] = NULL;
            
            $response = json_encode($response);
            print_r( $response );                
            
            exit;
        }
        $this->load->model( "syncfriends_model" );
        $response =  $this->syncfriends_model->highlightFriends( $user_id, $session_id,$contacts );
       
        return $response;
    }
}
?>