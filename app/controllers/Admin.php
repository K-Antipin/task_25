<?php

namespace App\controllers;

use App\core\Controller;
use App\data\DB;
use App\models\entities\User;
use stdClass;
use DateTime;

class Admin extends Controller
{
    public function index()
    {
        if ($_COOKIE['role'] !== 'staff') header('Location: /');
        $payload = DB::findAll('users');
        $this->view->render('user/users.phtml', 'template.phtml', $payload);
    }

    public function add()
    {
        $this->view->render('user/add.phtml', 'template.phtml');
    }

    public function create()
    {
        if (
            !isset($_POST)
            || $_SERVER["REQUEST_METHOD"] !== "POST"
        ) {
            header('Location: /admin/add');
        }

        $entity = new \stdClass();
        $entity->username = $_POST['username'];
        $entity->email = $_POST['email'];
        $entity->role = $_POST['role'];
        $user = new User($entity);
        $userId = DB::create($user, 'users');
        if ($userId) {
            header('Location: /admin');
        }
    }
    public function show($data)
    {
        if (!empty($data) && intval($data[0])) {
            $id = $data[0];
            $payload = DB::get('users', $id);
        }

        if (!isset($payload) || $payload['id'] === 0) {
            header('Location: /error');
        }
        $this->view->render('user/show.phtml', 'template.phtml', $payload);
    }



    public function loginIn()
    {
        http_response_code(200);

        if (!empty($_POST['login']) && !empty($_POST['password'])) {
            $user = DB::get('users', $_POST['login'], 'email = ?');
            $hash = $this->generateCode();
            if (!isset($user)) {
                die(json_encode(['error' => 'Пользователь не найден']));
            } else {
                if (\password_verify($_POST['password'], $user->password)) {
                    $obj = new stdClass;
                    $obj->id = $user->id;
                    $obj->user_hash = $hash;
                    $obj->user_ip = ip2long($_SERVER['REMOTE_ADDR']);
                    $obj->updated = time();
                    DB::update($obj, 'users');
                    setcookie("id", $user['id'], time() + 60 * 60 * 24 * 30, "/");
                    setcookie("name", $user['name'], time() + 60 * 60 * 24 * 30, "/");
                    setcookie('hash', $hash, time() + 60 * 60 * 24 * 30, '/', $_SERVER['SERVER_NAME'], false, true);
                    setcookie('role', $user['role'], time() + 60 * 60 * 24 * 30, '/', $_SERVER['SERVER_NAME'], false, true);
                    setcookie('auth', 1, time() + 60 * 60 * 24 * 30, '/', $_SERVER['SERVER_NAME'], false, true);
                    die(json_encode('Успешный вход'));
                    // \header('Location: /');
                } else {
                    die(json_encode(['error' => 'Не верный пароль']));
                }
            }
        } elseif (empty($_POST['login']) && !empty($_POST['password'])) {
            die(json_encode(['error' => 'Введите логин']));
        } elseif (!empty($_POST['login']) && empty($_POST['password'])) {
            die(json_encode(['error' => 'Введите пароль']));
        } elseif (empty($_POST['login']) && empty($_POST['password'])) {
            die(json_encode(['error' => 'Логин и пароль отсутствуют']));
        }
    }

    public function register()
    {
        http_response_code(200);
        // die(json_encode($_POST));
        if (!empty($_POST['name']) && !empty($_POST['email']) && !empty($_POST['password']) && !empty($_POST['passwordConfirm'])) {
            // die(json_encode($_POST));
            $LoginExists = DB::get('users', $_POST['email'], 'email = ?');
            $hash = $this->generateCode();
            if (!isset($LoginExists)) {
                // die(json_encode(["error" => "Все ок" , $_POST]));
                if ($_POST['password'] !== $_POST['passwordConfirm']) die(json_encode(["error" => "Пароль и подтверждение не совпадают"]));
                $obj = new stdClass;
                $obj->name = $_POST['name'];
                $obj->email = $_POST['email'];
                $obj->role = 'user';
                $obj->password = password_hash($_POST['password'], PASSWORD_DEFAULT);
                $obj->user_hash = $hash;
                $obj->user_ip = ip2long($_SERVER['REMOTE_ADDR']);
                $obj->created = DateTime::createFromFormat('U', time());
                $user = new User($obj);
                $id = DB::create($user, 'users');
                if ($id) {
                    setcookie("id", $id, time() + 60 * 60 * 24 * 30, "/");
                    setcookie("name", $_POST['name'], time() + 60 * 60 * 24 * 30, "/");
                    setcookie('hash', $hash, time() + 60 * 60 * 24 * 30, '/', $_SERVER['SERVER_NAME'], false, true);
                    setcookie('role', $user->role, time() + 60 * 60 * 24 * 30, '/', $_SERVER['SERVER_NAME'], false, true);
                    setcookie('auth', 1, time() + 60 * 60 * 24 * 30, '/', $_SERVER['SERVER_NAME'], false, true);
                    die(\json_encode('Успешная регистрация'));
                } else {
                    die(json_encode(['error' => 'Неизвестная ошибка']));
                }
            } else {
                die(json_encode(["error" => "Почта {$_POST['email']} уже зарегистрирована"]));
            }
        } else {
            die(json_encode(['error' => 'Неизвестная ошибка']));
        }
    }

    public function exit()
    {
        if (isset($_COOKIE['id']) and isset($_COOKIE['hash'])) {
            setcookie('id', '', time() - 3600 * 24 * 30 * 12, '/');
            setcookie('name', '', time() - 3600 * 24 * 30 * 12, '/');
            setcookie('hash', '', time() - 3600 * 24 * 30 * 12,  '/', $_SERVER['SERVER_NAME'], false, true);
            setcookie('role', '', time() - 3600 * 24 * 30 * 12,  '/', $_SERVER['SERVER_NAME'], false, true);
            setcookie('auth', 0, time() + 60 * 60 * 24 * 30, '/', $_SERVER['SERVER_NAME'], false, true);

            die(json_encode(['error' => \false, 'mess' => 'Куки удалены']));
        } else {
            die(json_encode(['error' => \true, 'mess' => 'Куки не найдены']));
        }
    }

    private function generateCode()
    {
        $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPRQSTUVWXYZ0123456789";
        $code = "";
        $clen = strlen($chars) - 1;
        while (strlen($code) < 10) {
            $code .= $chars[mt_rand(0, $clen)];
        }
        return $code;
    }
}
