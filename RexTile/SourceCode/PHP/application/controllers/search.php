<?php
class search extends CI_Controller {
    public function __construct() {
        parent::__construct();    
        $this->load->helper('form');
    }
    
    public function saveSearch(){
       $search = $this->input->post("search");
       $session_id = $this->input->post("session_id");
       $user_id = $this->input->post("user_id");
       $latitude = $this->input->post("latitude");
       $longitude = $this->input->post("longitude");
              
        // check for the session
        $this->load->model('recommendation_model');
        $verifiedSession = $this->recommendation_model->getUserId( $session_id, $user_id );
       
        if(!$verifiedSession) {
            return false;
        }
       
        $this->load->model('search_model');
        $response = $this->search_model->saveMySearch($search,$user_id,$latitude,$longitude);
        
        print_r($response);
        return $response;
    }
    
    public function showSearchHistory(){
        $session_id = $this->input->post("session_id");
        $user_id = $this->input->post("user_id");
        
        $this->load->model('search_model');
        $response = $this->search_model->getSearchHistory($user_id);
        
        print_r($response);
        return $response;
    }
    
}
?>