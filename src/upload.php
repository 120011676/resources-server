<?php
/**
 * Created by PhpStorm.
 * User: say
 * Date: 2018/5/25
 * Time: 14:21
 */

header('Content-Type:text/json;charset=utf-8');
$result = array('status' => true, 'code' => "0000", 'msg' => '成功!', 'data' => array());
if (empty($_FILES)) {
    $result["status"] = false;
    $result["code"] = "-0001";
    $result["msg"] = "没有选择上传文件!";
} else {
    foreach ($_FILES as $file) {
        $err = $file['error'];
        if (is_array($err)) {
            foreach ($err as $key => $error) {
                array_push($result['data'], upload(array('name' => $file['name'][$key], 'type' => $file['type'][$key], 'tmp_name' => $file['tmp_name'][$key], 'error' => $error, 'size' => $file['size'][$key])));
            }
        } else {
            array_push($result['data'], upload($file));
        }
    }
}
echo json_encode($result, JSON_UNESCAPED_UNICODE);

function upload($file)
{
    if ($file['error'] == UPLOAD_ERR_OK) {
        $file_path = './upload/';
        $file_name = intval(time()) . "_" . $file['name'];
        move_uploaded_file($file['tmp_name'], $file_path . $file_name);
        return array("url" => (empty($_SERVER['HTTP_X_CLIENT_PROTO']) ? 'http:' : $_SERVER['HTTP_X_CLIENT_PROTO'] . ':') . '//' . $_SERVER['HTTP_HOST'] . '/upload/' . $file_name, "name" => $file['name'], "size" => $file['size'], "type" => $file['type']);
    }
    return null;
}