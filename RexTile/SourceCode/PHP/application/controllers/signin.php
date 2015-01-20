<?php
class signin extends CI_Controller {
    public function __construct() {
        parent::__construct();
        $this->load->helper('form');
    }
    
    public function verify(){
        $verCode = $this->input->post("verCode");
        $session_id = $this->input->post("session_id");
        $this->load->model('signin_model');
        $response = $this->signin_model->doVerify($verCode,$session_id);
        print_r($response);
        return $response;
    }
}
?>