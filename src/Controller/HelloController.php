<?php

namespace App\Controller;

use App\Taxes\Calculator;
use App\Taxes\Detector;
use Psr\Log\LoggerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Response;

class  HelloController extends AbstractController
{
    protected Calculator $calculator;
    protected Detector $detector;
    public function __construct(Calculator $calculator,Detector $detector)

    {
        $this->calculator = $calculator;
        $this->detector = $detector;
    }

    #[Route('/hello/{name<[a-zA-Z]+>?World}', name: 'hello', host: 'localhost', methods: ['GET', 'POST'])]

    public function hello(string $name ,LoggerInterface $logger ,Detector $detector): Response
    {
        dump($detector->detect(1));
        dump($detector->detect(10));
        $logger->info('Saying hello to '.$name);
        $tva = $this->calculator->calcul(100);
        return new Response('Hello '.$name.'!');
    }
}
