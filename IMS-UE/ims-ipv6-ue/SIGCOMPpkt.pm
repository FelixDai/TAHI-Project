#!/usr/bin/perl 

# Copyright(C) IPv6 Promotion Council (2004-2010). All Rights Reserved.
# 
# This documentation is produced by SIP SWG members of Certification WG in 
# IPv6 Promotion Council.
# The SWG members currently include NIPPON TELEGRAPH AND TELEPHONE CORPORATION (NTT), 
# Yokogawa Electric Corporation and NTT Advanced Technology Corporation (NTT-AT).
# 
# 
# Redistribution and use of this software in source and binary forms, with 
# or without modification, are permitted provided that the following 
# conditions and disclaimer are agreed and accepted by the user:
# 
# 1. Redistributions of source code must retain the above copyright 
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright 
# notice, this list of conditions and the following disclaimer in the 
# documentation and/or other materials provided with the distribution.
# 
# 3. Neither the names of the copyrighters, the name of the project which 
# is related to this software (hereinafter referred to as "project") nor 
# the names of the contributors may be used to endorse or promote products 
# derived from this software without specific prior written permission.
# 
# 4. No merchantable use may be permitted without prior written 
# notification to the copyrighters. However, using this software for the 
# purpose of testing or evaluating any products including merchantable 
# products may be permitted without any notification to the copyrighters.
# 
# 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND 
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING 
# BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE 
# COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT,STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
# THE POSSIBILITY OF SUCH DAMAGE.

# use strict;
#============================================
# SIGCOMP
#============================================

# 
#   08/10/16 

#             form-1                            form-2                           NACK Message Format	     
#    0   1   2   3   4   5   6   7       0   1   2   3   4   5   6   7        0   1   2   3   4   5   6   7  
#  +---+---+---+---+---+---+---+---+   +---+---+---+---+---+---+---+---+   +---+---+---+---+---+---+---+---+ 
#  | 1   1   1   1   1 | T |  len  |   | 1   1   1   1   1 | T |   0   |   | 1   1   1   1   1 | T |   0   | 
#  +---+---+---+---+---+---+---+---+   +---+---+---+---+---+---+---+---+   +---+---+---+---+---+---+---+---+ 
#  |                               |   |                               |   |                               | 
#  :    returned feedback item     :   :    returned feedback item     :   :    returned feedback item     : 
#  |                               |   |                               |   |                               | 
#  +---+---+---+---+---+---+---+---+   +---+---+---+---+---+---+---+---+   +---+---+---+---+---+---+---+---+ 
#  |                               |   |           code_len            |   |         code_len = 0          | 
#  :   partial state identifier    :   +---+---+---+---+---+---+---+---+   +---+---+---+---+---+---+---+---+ 
# 									   | code_len = 0  |  version = 1  | 
#  |                               |   |   code_len    |  destination  |   +---+---+---+---+---+---+---+---+ 
#  +---+---+---+---+---+---+---+---+   +---+---+---+---+---+---+---+---+   |          Reason Code          | 
#  |                               |   |                               |   +---+---+---+---+---+---+---+---+ 
#  :   remaining SigComp message   :   :    uploaded UDVM bytecode     :   |  OPCODE of failed instruction | 
#  |                               |   |                               |   +---+---+---+---+---+---+---+---+ 
#  +---+---+---+---+---+---+---+---+   +---+---+---+---+---+---+---+---+   |   PC of failed instruction    | 
#                                      |                               |   |                               | 
#                                      :   remaining SigComp message   :   +---+---+---+---+---+---+---+---+ 
#                                      |                               |   |                               | 
#                                      +---+---+---+---+---+---+---+---+   : SHA-1 Hash of failed message  : 
# 									   |                               | 
# 									   +---+---+---+---+---+---+---+---+ 
# 									   |                               | 
# 									   :         Error Details         : 
# 									   |                               | 
# 									   +---+---+---+---+---+---+---+---+ 
#
#    0   1   2   3   4   5   6   7       0   1   2   3   4   5   6   7
#  +---+---+---+---+---+---+---+---+   +---+---+---+---+---+---+---+---+
#  | 0 |  returned_feedback_field  |   | 1 | returned_feedback_length  |
#  +---+---+---+---+---+---+---+---+   +---+---+---+---+---+---+---+---+
# 				       |                               |
# 				       :    returned_feedback_field    :
# 				       |                               |
# 				       +---+---+---+---+---+---+---+---+


@SIGCOMPHexMap =
(
 {'##'=>'SIGCOMP','#Name#'=>'SIGCOMP',
  'field'=>
      [
# 
       {'NM'=>'RemainMessage', 'DE'=>{'SZ'=>'REST','TY'=>'any',
				      'AC'=>sub{my($hexSt,$sigcpmp)=@_;SIGCOMPHexDEcode($sigcpmp,$hexSt);}},
# 
#        {'NM'=>'RemainMessage', 'DE'=>{'SZ'=>'REST','TY'=>'any',
# 				      'AC'=>\q{{SIGCOMPHexDEcode($F,$V);
# 						my($sip,$sc)=CtSigcompUnCompress(unpack('H*',$F));
# 						$HXpkt=unpack('H*',$sip);
# 						$NX='SIP';}}},
	'TXT'=>{'AC'=>\&SIGCOMPHexTxt}},
       ],
  },
 );

# SIGCOMP 
%UDVMInstruction = 
(
 1 => {'NM'=>'and', 'DS'=>'AND ($operand_1, %operand_2)',
       'DE'=>[{'NM'=>'$operand_1','TY'=>'reference'},
	      {'NM'=>'$operand_2','TY'=>'multitype'},
	      ]},
 2 => {'NM'=>'or', 'DS'=>'OR ($operand_1, %operand_2)',
       'DE'=>[{'NM'=>'$operand_1','TY'=>'reference'},
	      {'NM'=>'$operand_2','TY'=>'multitype'},
	      ]},
 3 => {'NM'=>'not', 'DS'=>'NOT ($operand_1)',
       'DE'=>[{'NM'=>'$operand_1','TY'=>'reference'},
	      ]},
 4 => {'NM'=>'lshift', 'DS'=>'LSHIFT ($operand_1, %operand_2)',
       'DE'=>[{'NM'=>'$operand_1','TY'=>'reference'},
	      {'NM'=>'$operand_2','TY'=>'multitype'},
	      ]},
 5 => {'NM'=>'rshift', 'DS'=>'RSHIFT ($operand_1, %operand_2)',
       'DE'=>[{'NM'=>'$operand_1','TY'=>'reference'},
	      {'NM'=>'$operand_2','TY'=>'multitype'},
	      ]},
 6 => {'NM'=>'add', 'DS'=>'ADD ($operand_1, %operand_2)',
       'DE'=>[{'NM'=>'$operand_1','TY'=>'reference'},
	      {'NM'=>'$operand_2','TY'=>'multitype'},
	      ]},
 7 => {'NM'=>'subtract', 'DS'=>'SUBTRACT ($operand_1, %operand_2)',
       'DE'=>[{'NM'=>'$operand_1','TY'=>'reference'},
	      {'NM'=>'$operand_2','TY'=>'multitype'},
	      ]},
 8 => {'NM'=>'multiply', 'DS'=>'MULTIPLY ($operand_1, %operand_2)',
       'DE'=>[{'NM'=>'$operand_1','TY'=>'reference'},
	      {'NM'=>'$operand_2','TY'=>'multitype'},
	      ]},
 9 => {'NM'=>'divide', 'DS'=>'DIVIDE ($operand_1, %operand_2)',
       'DE'=>[{'NM'=>'$operand_1','TY'=>'reference'},
	      {'NM'=>'$operand_2','TY'=>'multitype'},
	      ]},
 10 => {'NM'=>'remainder', 'DS'=>'REMAINDER ($operand_1, %operand_2)',
       'DE'=>[{'NM'=>'$operand_1','TY'=>'reference'},
	      {'NM'=>'$operand_2','TY'=>'multitype'},
	      ]},
 11 => {'NM'=>'sort-ascending', 'DS'=>'SORT-ASCENDING (%start, %n, %k)',
	'DE'=>'SCodeStop'},
 12 => {'NM'=>'sort-descending', 'DS'=>'SORT-DESCENDING (%start, %n, %k)', # 
	'DE'=>'SCodeStop'},
 13 => {'NM'=>'sha-1', 'DS'=>'SHA-1 (%position, %length, %destination)',
       'DE'=>[{'NM'=>'%position','TY'=>'multitype'},
	      {'NM'=>'%length','TY'=>'multitype'},
	      {'NM'=>'%destination','TY'=>'reference'},
	      ]},
 14 => {'NM'=>'load', 'DS'=>'LOAD (%address, %value)',
       'DE'=>[{'NM'=>'%address','TY'=>'multitype'},
	      {'NM'=>'%value','TY'=>'multitype'},
	      ]},
 15 => {'NM'=>'multiload', 'DS'=>'MULTILOAD (%address, #n, %value_0, ..., %value_n-1)',
       'DE'=>'SCodeMultiload'},
 16 => {'NM'=>'push', 'DS'=>'PUSH (%value)',
       'DE'=>[{'NM'=>'%value','TY'=>'multitype'},
	      ]},
 17 => {'NM'=>'pop', 'DS'=>'POP (%address)',
       'DE'=>[{'NM'=>'%address','TY'=>'multitype'},
	      ]},
 18 => {'NM'=>'copy', 'DS'=>'COPY (%position, %length, %destination)',
       'DE'=>[{'NM'=>'%position','TY'=>'multitype'},
	      {'NM'=>'%length','TY'=>'multitype'},
	      {'NM'=>'%destination','TY'=>'reference'},
	      ]},
 19 => {'NM'=>'copy-literal', 'DS'=>'COPY-LITERAL (%position, %length, $destination)',
       'DE'=>[{'NM'=>'%position','TY'=>'multitype'},
	      {'NM'=>'%length','TY'=>'multitype'},
	      {'NM'=>'%destination','TY'=>'reference'},
	      ]},
 20 => {'NM'=>'copy-offset', 'DS'=>'COPY-OFFSET (%offset, %length, $destination)',
       'DE'=>[{'NM'=>'%offset','TY'=>'multitype'},
	      {'NM'=>'%length','TY'=>'multitype'},
	      {'NM'=>'$destination','TY'=>'multitype'},
	      ]},
 21 => {'NM'=>'memset', 'DS'=>'MEMSET (%address, %length, %start_value, %offset)',
       'DE'=>[{'NM'=>'%address','TY'=>'multitype'},
	      {'NM'=>'%length','TY'=>'multitype'},
	      {'NM'=>'%start_value','TY'=>'multitype'},
	      {'NM'=>'%offset','TY'=>'multitype'},
	      ]},
 22 => {'NM'=>'jump', 'DS'=>'JUMP (@address)',
       'DE'=>[{'NM'=>'$operand_1','TY'=>'reference','AC'=>\q{($V+$UDVM_address) & 0xffff}},
	      ]},
 23 => {'NM'=>'compare', 'DS'=>'COMPARE (%value_1, %value_2, @address_1, @address_2, @address_3)',
       'DE'=>[{'NM'=>'%value_1','TY'=>'multitype'},
	      {'NM'=>'%value_2','TY'=>'multitype'},
	      {'NM'=>'@address_1','TY'=>'multitype','AC'=>\q{($V+$UDVM_address) & 0xffff}},
	      {'NM'=>'@address_2','TY'=>'multitype','AC'=>\q{($V+$UDVM_address) & 0xffff}},
	      {'NM'=>'@address_3','TY'=>'multitype','AC'=>\q{($V+$UDVM_address) & 0xffff}},
	      ]},
 24 => {'NM'=>'and', 'DS'=>'CALL (@address) (PUSH addr)',
	'DE'=>[{'NM'=>'@address','TY'=>'multitype','AC'=>\q{($V+$UDVM_address) & 0xffff}},
	      ]},
 25 => {'NM'=>'return', 'DS'=>'POP and return',
	'DE'=>'SCodeReturn'},
 26 => {'NM'=>'switch', 'DS'=>'SWITCH (#n, %j, @address_0, @address_1, ... , @address_n-1)',
	'DE'=>'SCodeSwitch'},
 27 => {'NM'=>'crc', 'DS'=>'CRC (%value, %position, %length, @address)',
       'DE'=>[{'NM'=>'%value','TY'=>'multitype'},
	      {'NM'=>'%position','TY'=>'multitype'},
	      {'NM'=>'%length','TY'=>'multitype'},
	      {'NM'=>'@address','TY'=>'multitype','AC'=>\q{($V+$UDVM_address) & 0xffff}},
	      ]},
 28 => {'NM'=>'input-bytes', 'DS'=>'INPUT-BYTES (%length, %destination, @address)',
       'DE'=>[{'NM'=>'%length','TY'=>'multitype'},
	      {'NM'=>'%destination','TY'=>'multitype'},
	      {'NM'=>'@address','TY'=>'multitype','AC'=>\q{($V+$UDVM_address) & 0xffff}},
	      ]},
 29 => {'NM'=>'input-bits', 'DS'=>'INPUT-BITS (%length, %destination, @address)',
       'DE'=>[{'NM'=>'%length','TY'=>'multitype'},
	      {'NM'=>'%destination','TY'=>'multitype'},
	      {'NM'=>'@address','TY'=>'multitype','AC'=>\q{($V+$UDVM_address) & 0xffff}},
	      ]},
 30 => {'NM'=>'huffman', 'DS'=>'INPUT-HUFFMAN (%destination, @address, #n, %bits_1, %lower_bound_1,%upper_bound_1, %uncompressed_1, ... , %bits_n, %lower_bound_n,%upper_bound_n, %uncompressed_n)',
	'DE'=>'SCodeHuffman'},
 31 => {'NM'=>'stateaccess', 'DS'=>'STATE-ACCESS (%partial_identifier_start, %partial_identifier_length,%state_begin, %state_length, %state_address, %state_instruction)',
       'DE'=>[{'NM'=>'%partial_identifier_start','TY'=>'multitype'},
	      {'NM'=>'%partial_identifier_length','TY'=>'multitype'},
	      {'NM'=>'%state_begin','TY'=>'multitype'},
	      {'NM'=>'%state_length','TY'=>'multitype'},
	      {'NM'=>'%state_address','TY'=>'multitype'},
	      {'NM'=>'%state_instruction','TY'=>'multitype'},
	      ]},
 32 => {'NM'=>'statecreate', 'DS'=>'STATE-CREATE (%state_length, %state_address, %state_instruction,%minimum_access_length, %state_retention_priority)',
       'DE'=>[{'NM'=>'%state_length','TY'=>'multitype'},
	      {'NM'=>'%state_address','TY'=>'multitype'},
	      {'NM'=>'%state_instruction','TY'=>'multitype'},
	      {'NM'=>'%minimum_access_length','TY'=>'multitype'},
	      {'NM'=>'%state_retention_priority','TY'=>'multitype'},
	      ]},
 33 => {'NM'=>'statefree', 'DS'=>'STATE-FREE (%partial_identifier_start, %partial_identifier_length)',
       'DE'=>[{'NM'=>'%partial_identifier_start','TY'=>'multitype'},
	      {'NM'=>'%partial_identifier_length','TY'=>'multitype'},
	      ]},
 34 => {'NM'=>'output', 'DS'=>'OUTPUT (%output_start, %output_length)',
       'DE'=>[{'NM'=>'%output_start','TY'=>'multitype'},
	      {'NM'=>'%output_length','TY'=>'multitype'},
	      ]},
 35 => {'NM'=>'end', 'DS'=>'END-MESSAGE (%requested_feedback_location,%returned_parameters_location, %state_length, %state_address,%state_instruction, %minimum_access_length,%state_retention_priority)',
	'DE'=>'SCodeEnd'},
 );

sub sc_get_byte {
    my($hex,$offset)=@_;
    return ord(substr($hex, $offset, 1));
}
sub sc_get_ntohs {
    my($hex,$offset)=@_;
    return unpack('n',substr($hex,$offset,2));
}
sub sc_get_long {
    my($hex,$offset)=@_;
    return unpack('N',substr($hex,$offset,4));
}

#============================================
# SIGCOMP
#============================================
sub SIGCOMPHexDEcode {
    my($hex,$inet)=@_;
    my($octet,$offset,$tbit,$partial_state_len,$returned_feedback_len,$returned_feedback_field,
       $partial_state,$destination,$bytecode_len,$remain_msg,$len,$nack_version,$bytecode_offset,$bytecode,$sc);
				     
    # 
    $hex = pack('H*',$hex);
    $offset = 0;
				     
    $octet = sc_get_byte($hex, $offset);
    $tbit = ($octet & 0x04)>>2;	     
    $partial_state_len = $octet & 0x03;
    $offset ++;			     
				     
    # 
    if ( $partial_state_len != 0 ){
	$partial_state_len = $partial_state_len * 3 + 3;
	if ( $tbit ) {
	    $returned_feedback_len = 1;
	    $octet = sc_get_byte($hex, $offset);
	    if ( ($octet & 0x80) != 0 ){
		$returned_feedback_len = $octet & 0x7f;
		$offset ++;
		$returned_feedback_field = unpack('H*',substr($hex,$offset,$returned_feedback_len));
	    }
	    else {
		$returned_feedback_field = unpack('H*',substr($hex, $offset, 1) & 0x7f);
	    }
	    $offset = $offset + $returned_feedback_len;
	}
	$partial_state = unpack('H*',substr($hex,$offset, $partial_state_len));
	$offset = $offset + $partial_state_len;
	$remain_msg = unpack('H*',substr($hex,$offset));

	$sc={'Bin'=>31,
	     'Tbit'=>$tbit,'PartialStateIDLength'=>$partial_state_len,
	     'ReturnFeedbakItem'=>$returned_feedback_field,'ReturnFeedbakLength'=>$returned_feedback_len,
	     'PartialStateID'=>$partial_state,
	     'RemainMessage'=>$remain_msg};
    }
    # 
    else{
	if ( $tbit ) {
	    # Returned feedback item exists
	    $returned_feedback_len = 1;
	    $octet = sc_get_byte($hex, $offset);
	    if ( ($octet & 0x80) != 0 ){
		$returned_feedback_len = $octet & 0x7f;
		$offset ++;
		$returned_feedback_field = unpack('H*',substr($hex,$offset,$returned_feedback_len));
	    }
	    else {
		$returned_feedback_field = unpack('H*',substr($hex, $offset, 1) & 0x7f);
	    }
	    $offset = $offset + $returned_feedback_len;
	}
	$len = sc_get_ntohs($hex, $offset) >> 4;

	$nack_version = sc_get_byte($hex, $offset+1) & 0x0f;
	if (($len == 0) && ($nack_version == 1)){
	    # NACK MESSAGE
	    printf("NACK MESSAGE\n");
	}
	else{
	    $octet = sc_get_byte($hex, ($offset + 1));
	    $destination = ($octet & 0x0f);
	    if ( $destination != 0 ){ $destination = 64 + ( $destination * 64 ); }
	    $offset = $offset +2;
	    $bytecode_len = $len;
	    $bytecode_offset = $offset;
	    $bytecode = unpack('H*',substr($hex,$bytecode_offset,$bytecode_len));
	    $offset = $offset + $len;
	    $remain_msg = unpack('H*',substr($hex,$offset));
	}
	$sc={'Bin'=>31,
	     'Tbit'=>$tbit,'PartialStateIDLength'=>$partial_state_len,
	     'ReturnFeedbakItem'=>$returned_feedback_field,'ReturnFeedbakLength'=>$returned_feedback_len,
	     'PartialStateID'=>$partial_state,
	     'CodeLength'=>$bytecode_len,'ByteCode'=>$bytecode,'RemainMessage'=>$remain_msg,'Destination'=>$destination};
    }
    %$inet=(%$inet,%$sc);
}

#============================================
# HTML
#============================================
sub SIGCOMPHexTxt {
    my($val,$name,$hex,$msgs,$level)=@_;
    my($item);
    if($hex->{'#COMPRESSION#'} ne ''){
	push(@$msgs,{'Field'=>'[Compression Rate]','Value'=>sprintf('%3.1f%%',$hex->{'#COMPRESSION#'}),'Level'=>$level});
    }
    foreach $item ('Bin','Tbit','PartialStateIDLength','ReturnFeedbakLength','ReturnFeedbakItem',
		   'PartialStateID','CodeLength','Destination','ByteCode'){
	if($hex->{$item} ne ''){
	    push(@$msgs,{'Field'=>$item,'Value'=>$hex->{$item},'Level'=>$level});
	}
    }
    return $hex->{'RemainMessage'};
}



#============================================
# bytecode 
#============================================

#   The simplest operand type is the literal (#), which encodes a
#  constant integer from 0 to 65535 inclusive.  A literal operand may
#  require between 1 and 3 bytes depending on its value.
#  Bytecode:                       Operand value:      Range:
#  0nnnnnnn                        N                   0 - 127
#  10nnnnnn nnnnnnnn               N                   0 - 16383
#  11000000 nnnnnnnn nnnnnnnn      N                   0 - 65535
sub SCodeoLiteralOp {
    my($bytecode,$offset)=@_;
    my($value,$start_offset,$code,$test_bits);

    $code = sc_get_byte($bytecode,$offset);
    $test_bits = $code >> 7;
    if ($test_bits eq 1){
	$test_bits = $code >> 6;
	if ($test_bits == 2){
	    $value = sc_get_ntohs($bytecode,$offset) & 0x3fff;
	    $start_offset = $offset;
	    $offset = $offset + 2;
	}
	else{
	    $offset ++;
	    $value = sc_get_ntohs($bytecode,$offset);
	    $start_offset = $offset;
	    $offset += 2;
	}
    }
    else{
	$value = ( $code & 0x7f);
	$start_offset = $offset;
	$offset ++;
    }
    return $offset,$value,$start_offset;
}

#   The simplest operand type is the literal (#), which encodes a
#  constant integer from 0 to 65535 inclusive.  A literal operand may
#  require between 1 and 3 bytes depending on its value.
#  Bytecode:                       Operand value:      Range:
#  0nnnnnnn                        N                   0 - 127
#  10nnnnnn nnnnnnnn               N                   0 - 16383
#  11000000 nnnnnnnn nnnnnnnn      N                   0 - 65535
sub SCodeReferenceOp {
    my($bytecode,$offset)=@_;
    my($value,$start_offset,$operand,$code,$test_bits);

    $code = sc_get_byte($bytecode,$offset);
    $test_bits = $code >> 7;
    if ($test_bits eq 1){
	$test_bits = $code >> 6;
	if ($test_bits eq 2){
	    $operand = sc_get_ntohs($bytecode,$offset) & 0x3fff;
	    $value = ($operand * 2);
	    $start_offset = $offset;
	    $offset += 2;
	}
	else{
	    $offset ++;
	    $operand = sc_get_ntohs($bytecode,$offset);
	    $value = $operand;
	    $start_offset = $offset;
	    $offset += 2;
	}
    }
    else{
	$operand = ( $code & 0x7f);
	$value = ($operand * 2);
	$start_offset = $offset;
	$offset++;
    }
    return $offset,$value,$start_offset;
}

#  RFC3320
#  Figure 10: Bytecode for a multitype (%) operand
#  Bytecode:                       Operand value:      Range:               HEX val
#  00nnnnnn                        N                   0 - 63				0x00
#  01nnnnnn                        memory[2 * N]       0 - 65535			0x40
#  1000011n                        2 ^ (N + 6)        64 , 128				0x86	
#  10001nnn                        2 ^ (N + 8)    256 , ... , 32768			0x88
#  111nnnnn                        N + 65504       65504 - 65535			0xe0
#  1001nnnn nnnnnnnn               N + 61440       61440 - 65535			0x90
#  101nnnnn nnnnnnnn               N                   0 - 8191				0xa0
#  110nnnnn nnnnnnnn               memory[N]           0 - 65535			0xc0
#  10000000 nnnnnnnn nnnnnnnn      N                   0 - 65535			0x80
#  10000001 nnnnnnnn nnnnnnnn      memory[N]           0 - 65535			0x81
sub SCodeMultitypeOp {
    my($bytecode,$offset)=@_;
    my($code,$test_bits,$value,$result,$is_memory_address,$start_offset);

    $code = sc_get_byte($bytecode, $offset);
    $test_bits = ( $code & 0xc0 ) >> 6;
    if($test_bits eq 0){
	$value = ( $code & 0x3f);
	$start_offset = $offset;
	$offset ++;
    }
    elsif($test_bits eq 1){
	$value = ( $code & 0x3f ) * 2;
	$is_memory_address = 'T';
	$start_offset = $offset;
	$offset ++;
    }
    elsif($test_bits eq 2){
	$test_bits = ( $code & 0xe0 ) >> 5;
	if ( $test_bits eq 5 ){
	    $value = sc_get_ntohs($bytecode, $offset) & 0x1fff;
	    $start_offset = $offset;
	    $offset += 2;
	}
	else {
	    $test_bits = ( $code & 0xf0 ) >> 4;
	    if ( $test_bits == 9 ){
		$value = (sc_get_ntohs($bytecode, $offset) & 0x0fff) + 61440;
		$start_offset = $offset;
		$offset += 2;
	    }
	    else{
		$test_bits = ( $code & 0x08 ) >> 3;
		if ( $test_bits eq 1){
		    $result = int(2**(($code & 0x07) + 8));
		    $value = $result & 0xffff;
		    $start_offset = $offset;
		    $offset ++;
		}
		else{
		    $test_bits = ( $code & 0x0e ) >> 1;
		    if ( $test_bits eq 3 ){
			$result = int(2**(( $code & 0x01) + 6));
			$value = $result & 0xffff;
			$start_offset = $offset;
			$offset ++;
		    }
		    else{
			if ( ($code & 0x01) == 1 ){$is_memory_address = 'T';}
			$offset ++;
			$value = sc_get_ntohs($bytecode,$offset);
			$start_offset = $offset;
			$offset += 2;
		    }
		}
	    }
	}
    }
    elsif($test_bits eq 3){
	$test_bits = ( $code & 0x20 ) >> 5;
	if ( $test_bits eq 1 ){
	    $value = ( $code & 0x1f) + 65504;
	    $start_offset = $offset;
	    $offset ++;
	}
	else{
	    $value = (sc_get_ntohs($bytecode,$offset) & 0x1fff);
	    $is_memory_address = 'T';
	    $start_offset = $offset;
	    $offset += 2;
	}
    }
    else{
    }
    return $offset,$value,$is_memory_address,$start_offset;
}

sub SCodeMultiload {
    my($bytecode,$offset)=@_;
    my(@args,$V,$is_memory_address,$start_offset,$n);

    # %address
    ($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
    push(@args,{'name'=>'%address','val'=>$V,'is-memad'=>$is_memory_address});

    # #n
    ($offset,$V,$start_offset) = SCodeoLiteralOp($bytecode, $offset);
    push(@args,{'name'=>'#n','val'=>$V});

    $n = $V;
    while(0 < $n){
	$n--;

	# %value
	($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
	push(@args,{'name'=>'%value','val'=>$V,'is-memad'=>$is_memory_address});
    }
    return \@args,$offset;
}

sub SCodeHuffman {
    my($bytecode,$offset)=@_;
    my(@args,$V,$is_memory_address,$start_offset,$n);

    # %destination
    ($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
    push(@args,{'name'=>'%destination','val'=>$V,'is-memad'=>$is_memory_address});

    # @address
    ($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
    $V = ( $V + $UDVM_address ) & 0xffff;
    push(@args,{'name'=>'%address','val'=>$V,'is-memad'=>$is_memory_address});

    # #n
    ($offset,$V,$start_offset) = SCodeoLiteralOp($bytecode, $offset);
    push(@args,{'name'=>'#n','val'=>$V});

    $n = $V;
    while(0 < $n){
	$n--;

	# %Bits_n
	($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
	push(@args,{'name'=>'%Bits_n','val'=>$V,'is-memad'=>$is_memory_address});

	# %lower_bound_n
	($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
	push(@args,{'name'=>'%lower_bound_n','val'=>$V,'is-memad'=>$is_memory_address});

	# %upper_bound_n
	($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
	push(@args,{'name'=>'%upper_bound_n','val'=>$V,'is-memad'=>$is_memory_address});

	# %uncompressed_n
	($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
	push(@args,{'name'=>'%uncompressed_n','val'=>$V,'is-memad'=>$is_memory_address});
    }

    return \@args,$offset;
}

sub SCodeSwitch {
    my($bytecode,$offset)=@_;
    my(@args,$V,$is_memory_address,$start_offset,$n);

    # #n
    ($offset,$V,$start_offset) = SCodeoLiteralOp($bytecode, $offset);
    push(@args,{'name'=>'#n','val'=>$V});
    $n = $V;

    # %j
    ($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
    push(@args,{'name'=>'%j','val'=>$V,'is-memad'=>$is_memory_address});

    while(0 < $n){
	$n--;

	# @address
	($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
	$V = ( $V + $UDVM_address ) & 0xffff;
	push(@args,{'name'=>'@address','val'=>$V,'is-memad'=>$is_memory_address});
    }
    return \@args,$offset;
}

sub SCodeReturn {
    my($bytecode,$offset)=@_;
    return '',$offset;
}

sub SCodeStop {
    my($bytecode,$offset,$total)=@_;
    return '',$total;
}

sub SCodeEnd {
    my($bytecode,$offset,$total)=@_;
    my(@args,$V,$is_memory_address,$start_offset);

    if($total<=$offset){return '',$offset;}

    # %requested_feedback_location
    ($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
    push(@args,{'name'=>'%requested_feedback_location','val'=>$V,'is-memad'=>$is_memory_address});
    if($total<=$offset){goto EXIT}

    # %returned_parameters_location
    ($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
    push(@args,{'name'=>'%returned_parameters_location','val'=>$V,'is-memad'=>$is_memory_address});

    # %state_length
    ($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
    push(@args,{'name'=>'%state_length','val'=>$V,'is-memad'=>$is_memory_address});

    # %state_address
    ($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
    push(@args,{'name'=>'%state_address','val'=>$V,'is-memad'=>$is_memory_address});

    # %state_instruction
    ($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
    push(@args,{'name'=>'%state_instruction','val'=>$V,'is-memad'=>$is_memory_address});

    # %minimum_access_length
    ($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
    push(@args,{'name'=>'%minimum_access_length','val'=>$V,'is-memad'=>$is_memory_address});

    if($offset<$total){
	# %state_retention_priority
	($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
	push(@args,{'name'=>'%state_retention_priority','val'=>$V,'is-memad'=>$is_memory_address});
    }

EXIT:
    return \@args,$offset;
}

# 
sub DisassembleBYTECODE {
    my($bytecode,$startAddress)=@_;
    my($offset,$udvmAddress,$bytecodeLen,$items,$item,@mnemonic,
       $mnemonic,$V,$is_memory_address,$start_offset,$instruction,$expr);
    
    $offset=0;
    $bytecodeLen = length($bytecode);
    while($offset < $bytecodeLen){
	$instruction = sc_get_byte($bytecode, $offset);
	$UDVM_address = $startAddress + $offset;

	printf("UDVM instruction code : %s\n",$UDVMInstruction{$instruction}->{'NM'});

	$offset++;
	$mnemonic = {'inst'=>$UDVMInstruction{$instruction}->{'NM'},'addr'=>$UDVM_address,'args'=>[]};
	$items=$UDVMInstruction{$instruction}->{'DE'};
	if(ref($items)){
	    foreach $item (@$items){
		if( $item->{'TY'} eq 'multitype' ){
		    ($offset,$V,$is_memory_address,$start_offset)=SCodeMultitypeOp($bytecode,$offset);
		}
		elsif( $item->{'TY'} eq 'reference' ){
		    ($offset,$V,$start_offset)=SCodeReferenceOp($bytecode,$offset);
		    $start_offset='';
		}
		if($expr = $item->{'AC'}){$V = eval $$expr;}
		push(@{$mnemonic->{'args'}},{'name'=>$item->{'NM'},'val'=>$V,'is-memad'=>$is_memory_address});
	    }
	}
	else{
	    ($mnemonic->{'args'},$offset)=$items->($bytecode,$offset,$bytecodeLen);
	}
	push(@mnemonic,$mnemonic);
    }
    return \@mnemonic;
}

# SIP
# CtPkAddPort(sub{my($palyload)=@_;return (0x80 <= hex(substr($palyload,0,2)))?'SIGCOMP':'SIP'},5060);

# 
# $bytecode=
#     '0f867ca2910000a29100030004000500' .
#     '06000700080009000a010b010d010f01' .
#     '1102130217021b021f0323032b033303' .
#     '3b04a04304a05304a06304a07305a083' .
#     '05a0a305a0c305a0e300a10200010002' .
#     '00030004010501070209020d03110319' .
#     '0421043105a04105a06106a08106a0c1' .
#     '07a10107a18108a20108a30109a40109' .
#     'a6010aa8010aac010bb0010bb8010c80' .
#     '20010c8030010d8040010d8060018a02' .
#     '1c01a1369fb21d01a1389fac17c13800' .
#     '9fa617080fa13804a6fb80e50780dfe5' .
#     '80e6000ea042891d032afb0421550621' .
#     'a2910e2c610716861d04a134ea02809a' .
#     '8a1e20a065040700178040110130a0bf' .
#     '0000a0c0a0c780402901a190a1ffa090' .
#     '175080401109a0461322210113210123' .
#     '169fd1081004125004221d51229fd706' .
#     '12511d05209fcf06102f081004125004' .
#     '261d53269fc00614530e206314545223' .
#     '225052169f9e23a134a1365686a1e606' ;

# DisassembleBYTECODE(pack('H*',$bytecode),320);

