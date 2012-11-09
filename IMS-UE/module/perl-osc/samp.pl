use ExtUtils::testlib;
use Data::Dumper;
use osc;

$id = 1000;
$data =
    "REGISTER sip:registrar.home1.net SIP/2.0\r\n" .
    "Via: SIP/2.0/UDP [5555::aaa:bbb:ccc:ddd];comp=sigcomp;branch=z9hG4bKnashds7\r\n" .
    "Max-Forwards: 70\r\n" .
    "Contact: <sip:[5555::aaa:bbb:ccc:ddd];comp=sigcomp>;expires=600000\r\n" .
    "Require: sec-agree\r\n" .
    "CSeq: 1 REGISTER\r\n" .
    "Supported: path\r\n" .
    "Content-Length: 0\r\n" ;

printf("original data leng[%d]\n",length($data));

$stateHandler = new osc::StateHandler();
$stateHandler->useSipDictionary();

$stack = new osc::Stack($stateHandler);
$dc = new osc::DeflateCompressor($stateHandler); 

$stack->addCompressor($dc);
$sigcomMessage = $stack->compressMessage($data, length($data), $id);
# print Dumper($sigcomMessage);

# get datagram from comress message
$comp = $sigcomMessage->getDatagramMessage();
printf("comp=%s\n",unpack('H*',$comp));

# get datagram length from comress message
$leng1 = $sigcomMessage->getDatagramLength();

printf("compressMessage OK. ID[%d] leng[%d]\n",$id, $leng1);

$leng2 = $stack->uncompressMessage($comp, $leng1, $data2, 2048, $sc);
$stack->provideCompartmentId($sc, $id2);

printf("uncompressMessage OK. leng[%s]  id[%s]\n",$leng2,$id2);
printf("uncomp=%s\n",$data2);
# print Dumper($sc);

