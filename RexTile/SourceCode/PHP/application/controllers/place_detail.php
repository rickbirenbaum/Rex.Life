<?php
class place_detail extends CI_Controller {
    public function __construct() {
        parent::__construct();
        $this->load->helper('form');
    }
    
    public function index(){        
        $user_id = $this->input->post("user_id");
        $session_id = $this->input->post("session_id");
        $place_id = $this->input->post("place_id");
        
        // check for the session
        $this->load->model('recommendation_model');
        $verifiedSession = $this->recommendation_model->getUserId( $session_id, $user_id );
       
        if(!$verifiedSession) {
            return false;
        }
        $this->load->model('place_detail_model');
        $response = $this->place_detail_model->getPlaceDetails($user_id,$place_id);
        print_r($response);
        return $response;
    }
}
?>