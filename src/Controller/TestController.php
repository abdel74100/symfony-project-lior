<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class TestController
{


     #[Route("/", name: 'index', host: 'localhost', methods: ['GET', 'POST'])]
     public function index(Request $request): Response
     {
          return new Response("Vous etes sur l'index");
     }

    #[Route("/test/{age<\d+>?0}", name: 'test_localhost', host: 'localhost', methods: ['GET', 'POST'])]
     public function test(Request $request, int $age): Response
     {
          return new Response("Vous avez $age ans");
     }
}