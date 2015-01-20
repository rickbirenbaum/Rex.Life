<?php
class activities extends CI_Controller {
    public function __construct() {
        parent::__construct();
        $this->load->helper('form');
    }
    
    public function index(){
        
        $session_id = $this->input->post("session_id");
        $user_id = $this->input->post("user_id");
        $this->load->model('activities_model');
        $response = $this->activities_model->showMyActivities($session_id, $user_id);
        print_r($response);
        return $response;
    }
}
?>