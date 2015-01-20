<?php
class settings extends CI_Controller {
    public function __construct() {
        parent::__construct();
        $this->load->helper('form');
    }
    
    public function index(){
        
        $session_id = $this->input->post("session_id");
        $user_id = $this->input->post("user_id");
       
        $this->load->model('settings_model');
        $response = $this->settings_model->showSettings($session_id, $user_id);
        print_r($response);
        return $response;
    }
}
?>