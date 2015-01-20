<?php
class recommendation extends CI_Controller {
    public function __construct() {
        parent::__construct();
         $this->load->helper('form');
    }
    
    public function index(){        
        $this->load->model('recommendation_model');
        $response = $this->recommendation_model->addRecommendation();
        
        print_r($response);
        return $response;
    }
    
    public function viewRecommendations(){
        $this->load->model('recommendation_model');
        $this->data = $this->recommendation_model->getRecommendations();     

        print_r($this->data);
        return $this->data;
        
    }
    
    public function viewRecommendationCounts(){
        $this->load->model('recommendation_model');
        $this->data = $this->recommendation_model->getRecommendationCounts();     

        print_r($this->data);
        return $this->data;
        
    }
    
    public function viewTryList(){
        $this->load->model('recommendation_model');
        $this->data = $this->recommendation_model->getTryList();     

        return $this->data;
        
    }
    
    public function moveToRecommendation(){
        $user_id= $this->input->post('user_id');                        
        $sessionId = $this->input->post('session_id');
        $this->load->model('recommendation_model');
        $id = $this->input->post('place_id');
        $this->data = $this->recommendation_model->moveTryListPlaceToRecommendation( $sessionId,$user_id, $id);     

        print_r($this->data);
        return $this->data;
        
    }
    
     public function deleteTryOrRec(){
        $user_id= $this->input->post('user_id');                        
        $sessionId = $this->input->post('session_id');
        $place_id = $this->input->post('place_id');
        $this->load->model('recommendation_model');
        $this->data = $this->recommendation_model->removeRecommendations($sessionId, $user_id, $place_id);     

        print_r($this->data);
        return $this->data;
        
    }
    
    public function categories() {
        $this->load->model('recommendation_model');
        $this->data = $this->recommendation_model->getAllCategories();
       
        return $this->data;
    }
    
    public function getPlaceRecommendations() {
        $user_id= $this->input->post('user_id');                        
        $session_id = $this->input->post('session_id');
       
        $place_ids = explode( ',', $this->input->post( 'place_ids' ) );
        
        $this->load->model('recommendation_model');
        $verifiedSession = $this->recommendation_model->getUserId( $session_id, $user_id );        
        
         // check for the session
         if(!$verifiedSession) {
                return false;
         }
        $this->recommendation_model->getRecommendationsByPlaceIds( $place_ids, $user_id );            
        return true;
    }
    
    public function sendRecommendationSms() {
        $user_id= $this->input->post('user_id');                        
        $session_id = $this->input->post('session_id');
       
        $place_id = $this->input->post( 'place_id' );
        
        $contacts = explode( ',', $this->input->post( 'contacts' ) );
        if( !is_array($contacts ) || empty($contacts) ) {
            $response["status"] = "Failure";
            $response["error"] = array("errcode"=>"101", "errormsg"=>"Please select valid contacts");
            
            $response = json_encode($response);
            print_r( $response );                
            
            exit;
        }
        $this->load->model('recommendation_model');
        $verifiedSession = $this->recommendation_model->getUserId( $session_id, $user_id );        
        
         // check for the session
         if(!$verifiedSession) {
                return false;
         }
        $this->recommendation_model->sendRecommendationSmsToUsers( $user_id,$contacts,$place_id );       
        return true;
    }
    
     public function getPlacesRecommendationCount() {
        $user_id= $this->input->post('user_id');                        
        $session_id = $this->input->post('session_id');       
        
        $place_ids = explode( ',', $this->input->post( 'place_ids' ) );
        if( !is_array($place_ids ) || empty($place_ids) ) {
            $response["status"] = "Success";
            $response["error"] = array("place_id"=>"", "count"=>"");
            
            $response = json_encode($response);
            print_r( $response );                
            
            exit;
        }
        $this->load->model('recommendation_model');
        $verifiedSession = $this->recommendation_model->getUserId( $session_id, $user_id );        
        
        
        
         // check for the session
         if(!$verifiedSession) {
                return false;
         }
        $this->recommendation_model->getRecommendationsCountByPlaceIds( $place_ids );       
        return true;
     }
    
  }
?>