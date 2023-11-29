<?php

namespace App\Controller;

use App\Taxes\Calculator;
use Psr\Log\LoggerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Response;

class  HelloController extends AbstractController
{
    protected Calculator $calculator;
    public function __construct(Calculator $calculator)

    {
        $this->calculator = $calculator;
    }

    #[Route('/hello/{name<[a-zA-Z]+>?World}', name: 'hello', host: 'localhost', methods: ['GET', 'POST'])]

    public function hello(string $name ,LoggerInterface $logger): Response
    {
        $logger->info('Saying hello to '.$name);
        $tva = $this->calculator->calcul(100);
        return new Response('Hello '.$name.'!'.$tva);
    }
}
