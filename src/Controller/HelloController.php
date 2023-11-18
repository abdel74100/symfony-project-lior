<?php

namespace App\Controller;

use Psr\Log\LoggerInterface;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Response;

class HelloController
{
public function __construct(LoggerInterface $logger){
    $this->logger = $logger;
}
    #[Route('/hello/{name<[a-zA-Z]+>?World}', name: 'hello', host: 'localhost', methods: ['GET', 'POST'])]

    public function index(string $name): Response
    {
        $this->logger->info('Saying hello to '.$name);
        return new Response('Hello '.$name.'!');
    }
}
