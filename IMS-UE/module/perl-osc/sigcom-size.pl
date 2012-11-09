use ExtUtils::testlib;
use Data::Dumper;
use osc;

@Message =
(
 {'from' => 'Alice',
  'data' => 
      "REGISTER sip:estacado.net SIP/2.0\r\n" .
      "Via: SIP/2.0/UDP 172.17.1.247:2078;branch=z9hG4bK-et736vsjirav;rport\r\n" .
      "From: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=6to4gh7t5j\r\n" .
      "To: \"Adam Roach\" <sip:2145550500\@estacado.net>\r\n" .
      "Call-ID: 3c26700c1adb-lu1lz5ri5orr\@widget3000\r\n" .
      "CSeq: 215196 REGISTER\r\n" .
      "Max-Forwards: 70\r\n" .
      "Contact: <sip:2145550500\@172.17.1.247:2078;line=cbqgzeby>;q=1.0;" .
      "+sip.instance=\"<urn:uuid:2e5fdc76-00be-4314-8202-1116fa82a473>\"" .
      ";audio;mobility=\"fixed\";duplex=\"full\";description=\"widget3000\"" .
      ";actor=\"principal\";events=\"dialog\";methods=\"INVITE,ACK,CANCEL," .
      "BYE,REFER,OPTIONS,NOTIFY,SUBSCRIBE,PRACK,MESSAGE,INFO\"\r\n" .
      "Supported: gruu\r\n" .
      "Allow-Events: dialog\r\n" .
      "Authorization: Digest username=\"2145550500\",realm=\"estacado.net\"," .
      "nonce=\"4191a4cd\",uri=\"sip:estacado.net\"," .
      "response=\"4e37bd0095dfc8667dbee0c3bb5ffd44\",algorithm=md5\r\n" .
      "Expires: 60\r\n" .
      "Content-Length: 0\r\n" .
      "\r\n"
  },
 {'from' => 'Alice',
  'data' => 
      "SIP/2.0 200 OK\r\n" .
      "Via: SIP/2.0/UDP 172.17.1.247:2078;branch=z9hG4bK-et736vsjirav\r\n" .
      "From: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=6to4gh7t5j\r\n" .
      "To: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=as7f1d7e54\r\n" .
      "Call-ID: 3c26700c1adb-lu1lz5ri5orr\@widget3000\r\n" .
      "CSeq: 215196 REGISTER\r\n" .
      "Allow: INVITE, ACK, CANCEL, OPTIONS, BYE, REFER\r\n" .
      "Expires: 60\r\n" .
      "Contact: <sip:2145550500\@172.17.1.247:2078;line=cbqgzeby>;expires=60\r\n" .
      "Date: Fri, 06 Jan 2006 18:26:28 GMT\r\n" .
      "Content-Length: 0\r\n" .
      "\r\n"
  },
 {'from' => 'Alice',
  'data' => 
      "INVITE sip:2145550444\@estacado.net;user=phone SIP/2.0\r\n" .
      "Via: SIP/2.0/UDP 172.17.1.247:2078;branch=z9hG4bK-6vi6sa58smfx;rport\r\n" .
      "From: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=4at3wehz8c\r\n" .
      "To: \"Voicemail\" <sip:2145550444\@estacado.net;user=phone>\r\n" .
      "Call-ID: 3c58339ed1f6-lvfoul2ixa8h\@widget3000\r\n" .
      "CSeq: 1 INVITE\r\n" .
      "Max-Forwards: 70\r\n" .
      "Contact: <sip:2145550500\@172.17.1.247:2078;line=cbqgzeby>\r\n" .
      "P-Key-Flags: resolution=\"31x13\", keys=\"4\"\r\n" .
      "Accept: application/sdp\r\n" .
      "Allow: INVITE, ACK, CANCEL, BYE, REFER, OPTIONS, NOTIFY, SUBSCRIBE, PRACK, MESSAGE, INFO\r\n" .
      "Allow-Events: talk, hold, refer\r\n" .
      "Supported: timer, 100rel, replaces, callerid\r\n" .
      "Session-Expires: 3600\r\n" .
      "Content-Type: application/sdp\r\n" .
      "Content-Length: 466\r\n" .
      "\r\n" .
      "v=0\r\n" .
      "o=root 1411917766 1411917766 IN IP4 172.17.1.247\r\n" .
      "s=call\r\n" .
      "c=IN IP4 172.17.1.247\r\n" .
      "t=0 0\r\n" .
      "m=audio 61586 RTP/AVP 0 8 3 18 4 9 101\r\n" .
      "k=base64:0XKVWY0qqljRgu1C5HlBIug4puMhqo022Hxow5KcKtE=\r\n" .
      "a=rtpmap:0 pcmu/8000\r\n" .
      "a=rtpmap:8 pcma/8000\r\n" .
      "a=rtpmap:3 gsm/8000\r\n" .
      "a=rtpmap:18 g729/8000\r\n" .
      "a=rtpmap:4 g723/8000\r\n" .
      "a=rtpmap:9 g722/8000\r\n" .
      "a=rtpmap:101 telephone-event/8000\r\n" .
      "a=fmtp:101 0-15\r\n" .
      "a=ptime:20\r\n" .
      "a=encryption:optional\r\n" .
      "a=alt:1 0.9 : user 9kksj== 172.17.1.247 61586\r\n" .
      "a=sendrecv\r\n"
  },
 {'from' => 'Bob',
  'data' => 
      "SIP/2.0 407 Proxy Authentication Required\r\n" .
      "Via: SIP/2.0/UDP 172.17.1.247:2078;branch=z9hG4bK-6vi6sa58smfx\r\n" .
      "From: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=4at3wehz8c\r\n" .
      "To: \"Voicemail\" <sip:2145550444\@estacado.net;user=phone>;tag=as3f1ef6ee\r\n" .
      "Call-ID: 3c58339ed1f6-lvfoul2ixa8h\@widget3000\r\n" .
      "CSeq: 1 INVITE\r\n" .
      "Allow: INVITE, ACK, CANCEL, OPTIONS, BYE, REFER\r\n" .
      "Contact: <sip:2145550444\@172.16.1.5>\r\n" .
      "Proxy-Authenticate: Digest realm=\"estacado.net\", nonce=\"0665e6a2\"\r\n" .
      "Content-Length: 0\r\n" .
      "\r\n"
  },
 {'from' => 'Alice',
  'data' => 
      "ACK sip:2145550444\@estacado.net;user=phone SIP/2.0\r\n" .
      "Via: SIP/2.0/UDP 172.17.1.247:2078;branch=z9hG4bK-6vi6sa58smfx;rport\r\n" .
      "From: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=4at3wehz8c\r\n" .
      "To: \"Voicemail\" <sip:2145550444\@estacado.net;user=phone>;tag=as3f1ef6ee\r\n" .
      "Call-ID: 3c58339ed1f6-lvfoul2ixa8h\@widget3000\r\n" .
      "CSeq: 1 ACK\r\n" .
      "Max-Forwards: 70\r\n" .
      "Contact: <sip:2145550500\@172.17.1.247:2078;line=cbqgzeby>\r\n" .
      "Content-Length: 0\r\n" .
      "\r\n"
  },
 {'from' => 'Alice',
  'data' => 
      "INVITE sip:2145550444\@estacado.net;user=phone SIP/2.0\r\n" .
      "Via: SIP/2.0/UDP 172.17.1.247:2078;branch=z9hG4bK-mvomytni0j9l;rport\r\n" .
      "From: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=4at3wehz8c\r\n" .
      "To: \"Voicemail\" <sip:2145550444\@estacado.net;user=phone>\r\n" .
      "Call-ID: 3c58339ed1f6-lvfoul2ixa8h\@widget3000\r\n" .
      "CSeq: 2 INVITE\r\n" .
      "Max-Forwards: 70\r\n" .
      "Contact: <sip:2145550500\@172.17.1.247:2078;line=cbqgzeby>\r\n" .
      "P-Key-Flags: resolution=\"31x13\", keys=\"4\"\r\n" .
      "Accept: application/sdp\r\n" .
      "Allow: INVITE, ACK, CANCEL, BYE, REFER, OPTIONS, NOTIFY, SUBSCRIBE, PRACK, MESSAGE, INFO\r\n" .
      "Allow-Events: talk, hold, refer\r\n" .
      "Supported: timer, 100rel, replaces, callerid\r\n" .
      "Session-Expires: 3600\r\n" .
      "Proxy-Authorization: Digest username=\"2145550500\",realm=\"estacado.net\",nonce=\"0665e6a2\"," .
      "uri=\"sip:2145550444\@estacado.net;user=phone\"," .
      "response=\"b33f66e6612daffeee07099387fcf95a\",algorithm=md5\r\n" .
      "Content-Type: application/sdp\r\n" .
      "Content-Length: 466\r\n" .
      "\r\n" .
      "v=0\r\n" .
      "o=root 1411917766 1411917766 IN IP4 172.17.1.247\r\n" .
      "s=call\r\n" .
      "c=IN IP4 172.17.1.247\r\n" .
      "t=0 0\r\n" .
      "m=audio 61586 RTP/AVP 0 8 3 18 4 9 101\r\n" .
      "k=base64:0XKVWY0qqljRgu1C5HlBIug4puMhqo022Hxow5KcKtE=\r\n" .
      "a=rtpmap:0 pcmu/8000\r\n" .
      "a=rtpmap:8 pcma/8000\r\n" .
      "a=rtpmap:3 gsm/8000\r\n" .
      "a=rtpmap:18 g729/8000\r\n" .
      "a=rtpmap:4 g723/8000\r\n" .
      "a=rtpmap:9 g722/8000\r\n" .
      "a=rtpmap:101 telephone-event/8000\r\n" .
      "a=fmtp:101 0-15\r\n" .
      "a=ptime:20\r\n" .
      "a=encryption:optional\r\n" .
      "a=alt:1 0.9 : user 9kksj== 172.17.1.247 61586\r\n" .
      "a=sendrecv\r\n"
  },
 {'from' => 'Bob',
  'data' => 
      "SIP/2.0 100 Trying\r\n" .
      "Via: SIP/2.0/UDP 172.17.1.247:2078;branch=z9hG4bK-mvomytni0j9l\r\n" .
      "From: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=4at3wehz8c\r\n" .
      "To: \"Voicemail\" <sip:2145550444\@estacado.net;user=phone>;tag=as6d8c19c7\r\n" .
      "Call-ID: 3c58339ed1f6-lvfoul2ixa8h\@widget3000\r\n" .
      "CSeq: 2 INVITE\r\n" .
      "Allow: INVITE, ACK, CANCEL, OPTIONS, BYE, REFER\r\n" .
      "Contact: <sip:2145550444\@172.16.1.5>\r\n" .
      "Content-Length: 0\r\n" .
      "\r\n"
  },
 {'from' => 'Bob',
  'data' => 
      "SIP/2.0 200 OK\r\n" .
      "Via: SIP/2.0/UDP 172.17.1.247:2078;branch=z9hG4bK-mvomytni0j9l\r\n" .
      "From: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=4at3wehz8c\r\n" .
      "To: \"Voicemail\" <sip:2145550444\@estacado.net;user=phone>;tag=as6d8c19c7\r\n" .
      "Call-ID: 3c58339ed1f6-lvfoul2ixa8h\@widget3000\r\n" .
      "CSeq: 2 INVITE\r\n" .
      "Allow: INVITE, ACK, CANCEL, OPTIONS, BYE, REFER\r\n" .
      "Contact: <sip:2145550444\@172.16.1.5>\r\n" .
      "Content-Type: application/sdp\r\n" .
      "Content-Length: 212\r\n" .
      "\r\n" .
      "v=0\r\n" .
      "o=root 3086 3086 IN IP4 172.16.1.5\r\n" .
      "s=session\r\n" .
      "c=IN IP4 172.16.1.5\r\n" .
      "t=0 0\r\n" .
      "m=audio 14322 RTP/AVP 0 101\r\n" .
      "a=rtpmap:0 PCMU/8000\r\n" .
      "a=rtpmap:101 telephone-event/8000\r\n" .
      "a=fmtp:101 0-16\r\n" .
      "a=silenceSupp:off - - - -\r\n"
  },
 {'from' => 'Alice',
  'data' => 
      "ACK sip:2145550444\@172.16.1.5 SIP/2.0\r\n" .
      "Via: SIP/2.0/UDP 172.17.1.247:2078;branch=z9hG4bK-q4jlg3rw6hog;rport\r\n" .
      "From: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=4at3wehz8c\r\n" .
      "To: \"Voicemail\" <sip:2145550444\@estacado.net;user=phone>;tag=as6d8c19c7\r\n" .
      "Call-ID: 3c58339ed1f6-lvfoul2ixa8h\@widget3000\r\n" .
      "CSeq: 2 ACK\r\n" .
      "Max-Forwards: 70\r\n" .
      "Contact: <sip:2145550500\@172.17.1.247:2078;line=cbqgzeby>\r\n" .
      "Content-Length: 0\r\n" .
      "\r\n"
  },
 {'from' => 'Alice',
  'data' => 
      "BYE sip:2145550444\@172.16.1.5 SIP/2.0\r\n" .
      "Via: SIP/2.0/UDP 172.17.1.247:2078;branch=z9hG4bK-mhsswpesd0a7;rport\r\n" .
      "From: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=4at3wehz8c\r\n" .
      "To: \"Voicemail\" <sip:2145550444\@estacado.net;user=phone>;tag=as6d8c19c7\r\n" .
      "Call-ID: 3c58339ed1f6-lvfoul2ixa8h\@widget3000\r\n" .
      "CSeq: 3 BYE\r\n" .
      "Max-Forwards: 70\r\n" .
      "Contact: <sip:2145550500\@172.17.1.247:2078;line=cbqgzeby>\r\n" .
      "Content-Length: 0\r\n" .
      "\r\n"
  },
 {'from' => 'Bob',
  'data' => 
      "SIP/2.0 200 OK\r\n" .
      "Via: SIP/2.0/UDP 172.17.1.247:2078;branch=z9hG4bK-mhsswpesd0a7\r\n" .
      "From: \"Adam Roach\" <sip:2145550500\@estacado.net>;tag=4at3wehz8c\r\n" .
      "To: \"Voicemail\" <sip:2145550444\@estacado.net;user=phone>;tag=as6d8c19c7\r\n" .
      "Call-ID: 3c58339ed1f6-lvfoul2ixa8h\@widget3000\r\n" .
      "CSeq: 3 BYE\r\n" .
      "Allow: INVITE, ACK, CANCEL, OPTIONS, BYE, REFER\r\n" .
      "Contact: <sip:2145550444\@172.16.1.5>\r\n" .
      "Content-Length: 0\r\n"
  },
);

sub FormatLine {
    my $format=shift;
    $^A = "";
    formline($format,@_);
    return $^A;
}

sub test_osc_Stack_oneCallUdp()
{
  # Set up Alice's environment
  $aliceSh = new osc::StateHandler(8192,64,8192,2);
  $aliceSh->useSipDictionary();
  $aliceStack = new osc::Stack($aliceSh);
  $aliceStack->addCompressor(new osc::DeflateCompressor($aliceSh));

  # Set up Bob's environment
  $bobSh = new osc::StateHandler(8192,64,8192,2);
  $bobSh->useSipDictionary();
  $bobStack = new osc::Stack($bobSh);
  $bobStack->addCompressor(new osc::DeflateCompressor($bobSh));

  $compartmentId = 0x12345678;

  foreach $msg (@Message){
      if( $msg->{'from'} eq 'Alice'){
	  $sigcompMessage = $aliceStack->compressMessage($msg->{'data'},length($msg->{'data'}),$compartmentId);
	  $outputSize = $bobStack->uncompressMessage($sigcompMessage->getDatagramMessage(), 
						     $sigcompMessage->getDatagramLength(),
						     $output, 8192, $stateChanges);

	  $bobStack->provideCompartmentId($stateChanges, $compartmentId);

	  # Check for NACK
	  $n = $bobStack->getNack();
	  if($n){printf($n);}
      }
      else
      {
	  $sigcompMessage = $bobStack->compressMessage($msg->{'data'},length($msg->{'data'}),$compartmentId);
	  $outputSize = $aliceStack->uncompressMessage($sigcompMessage->getDatagramMessage(), 
						       $sigcompMessage->getDatagramLength(),
						       $output, 8192, $stateChanges);

	  $aliceStack->provideCompartmentId($stateChanges, $compartmentId);

	  # Check for NACK
	  $n = $aliceStack->getNack();
	  if($n){printf($n);}
      }
      $origSize = length($msg->{'data'});
      $compSize = $sigcompMessage->getDatagramLength();

      if( $msg->{'data'} =~ /^((?:REGISTER|INVITE|ACK|BYE)) / ){
	  $id = $1;
      }
      if( $msg->{'data'} =~ /^SIP\/2\.0 ([0-9]+)/ ){
	  $id = $1;
      }

      $msg = FormatLine('Message @> [@>>>>>>>]: (@<<<), from @>>> to @>>> bytes (@###.#%% original)',
			$no++,$id,$msg->{'from'} eq 'Alice' ? 'a->b':'b->a',$origSize,$compSize,($compSize * 100) / $origSize);
      printf($msg . "\n");
      
      undef $sigcompMessage;
  }
}

test_osc_Stack_oneCallUdp();

