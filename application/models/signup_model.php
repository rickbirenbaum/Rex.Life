<?php
class signup_model extends CI_Model {
    public function saveSignUp($phone, $sessionId) {
        // $phone = '01234567891';
        //$name = 'shagufta';
        // $email= 'shagufta.murshad@perennialsys.com';
        $email = '';
        $name ='';
      
        $date = date('Y-m-d h:i:s');       
        $result= $this->db->query("INSERT INTO `users` (`id`, `phone`, `name`, `email_id`, `created_date` ,`session_id`)".
                "VALUES ('', ".$this->db->escape($phone)."," .$this->db->escape($name).",".
                $this->db->escape($email).",".$this->db->escape($date).",".$this->db->escape($sessionId) .")");
         
        if($result){
            return array( 'phone' => $phone, 'user_id' => mysql_insert_id() );
        } else {           
            return false;
        }
    }
       
    public function getSignUpDetails($phone){
       
        $query = $this->db->query("SELECT * FROM (`users`) WHERE `phone`='" . $phone ."'");     
        $result = $query->result();
       
        foreach($result as $row) {
            return array('user_id' => $row->id, 'phone' => $row->phone, 'name' => $row->name, 'email' =>  $row->email_id );
        }
       
    }
     
}
?>