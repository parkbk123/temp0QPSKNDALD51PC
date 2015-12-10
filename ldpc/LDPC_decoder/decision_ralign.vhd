library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	decision_ralign	 is         
port(
   
   decision        : in  std_logic_vector(511 downto 0);
   decision_align  : out std_logic_vector(511 downto 0)
	);	 
end	decision_ralign;

architecture rtl of decision_ralign is
 begin  
decision_align(0) <= decision(0);
decision_align(32) <= decision(1);
decision_align(64) <= decision(2);
decision_align(96) <= decision(3);
decision_align(128) <= decision(4);
decision_align(160) <= decision(5);
decision_align(192) <= decision(6);
decision_align(224) <= decision(7);
decision_align(2) <= decision(8);
decision_align(34) <= decision(9);
decision_align(66) <= decision(10);
decision_align(98) <= decision(11);
decision_align(130) <= decision(12);
decision_align(162) <= decision(13);
decision_align(194) <= decision(14);
decision_align(226) <= decision(15);
decision_align(4) <= decision(16);
decision_align(36) <= decision(17);
decision_align(68) <= decision(18);
decision_align(100) <= decision(19);
decision_align(132) <= decision(20);
decision_align(164) <= decision(21);
decision_align(196) <= decision(22);
decision_align(228) <= decision(23);
decision_align(6) <= decision(24);
decision_align(38) <= decision(25);
decision_align(70) <= decision(26);
decision_align(102) <= decision(27);
decision_align(134) <= decision(28);
decision_align(166) <= decision(29);
decision_align(198) <= decision(30);
decision_align(230) <= decision(31);
decision_align(8) <= decision(32);
decision_align(40) <= decision(33);
decision_align(72) <= decision(34);
decision_align(104) <= decision(35);
decision_align(136) <= decision(36);
decision_align(168) <= decision(37);
decision_align(200) <= decision(38);
decision_align(232) <= decision(39);
decision_align(10) <= decision(40);
decision_align(42) <= decision(41);
decision_align(74) <= decision(42);
decision_align(106) <= decision(43);
decision_align(138) <= decision(44);
decision_align(170) <= decision(45);
decision_align(202) <= decision(46);
decision_align(234) <= decision(47);
decision_align(12) <= decision(48);
decision_align(44) <= decision(49);
decision_align(76) <= decision(50);
decision_align(108) <= decision(51);
decision_align(140) <= decision(52);
decision_align(172) <= decision(53);
decision_align(204) <= decision(54);
decision_align(236) <= decision(55);
decision_align(14) <= decision(56);
decision_align(46) <= decision(57);
decision_align(78) <= decision(58);
decision_align(110) <= decision(59);
decision_align(142) <= decision(60);
decision_align(174) <= decision(61);
decision_align(206) <= decision(62);
decision_align(238) <= decision(63);
decision_align(16) <= decision(64);
decision_align(48) <= decision(65);
decision_align(80) <= decision(66);
decision_align(112) <= decision(67);
decision_align(144) <= decision(68);
decision_align(176) <= decision(69);
decision_align(208) <= decision(70);
decision_align(240) <= decision(71);
decision_align(18) <= decision(72);
decision_align(50) <= decision(73);
decision_align(82) <= decision(74);
decision_align(114) <= decision(75);
decision_align(146) <= decision(76);
decision_align(178) <= decision(77);
decision_align(210) <= decision(78);
decision_align(242) <= decision(79);
decision_align(20) <= decision(80);
decision_align(52) <= decision(81);
decision_align(84) <= decision(82);
decision_align(116) <= decision(83);
decision_align(148) <= decision(84);
decision_align(180) <= decision(85);
decision_align(212) <= decision(86);
decision_align(244) <= decision(87);
decision_align(22) <= decision(88);
decision_align(54) <= decision(89);
decision_align(86) <= decision(90);
decision_align(118) <= decision(91);
decision_align(150) <= decision(92);
decision_align(182) <= decision(93);
decision_align(214) <= decision(94);
decision_align(246) <= decision(95);
decision_align(24) <= decision(96);
decision_align(56) <= decision(97);
decision_align(88) <= decision(98);
decision_align(120) <= decision(99);
decision_align(152) <= decision(100);
decision_align(184) <= decision(101);
decision_align(216) <= decision(102);
decision_align(248) <= decision(103);
decision_align(26) <= decision(104);
decision_align(58) <= decision(105);
decision_align(90) <= decision(106);
decision_align(122) <= decision(107);
decision_align(154) <= decision(108);
decision_align(186) <= decision(109);
decision_align(218) <= decision(110);
decision_align(250) <= decision(111);
decision_align(28) <= decision(112);
decision_align(60) <= decision(113);
decision_align(92) <= decision(114);
decision_align(124) <= decision(115);
decision_align(156) <= decision(116);
decision_align(188) <= decision(117);
decision_align(220) <= decision(118);
decision_align(252) <= decision(119);
decision_align(30) <= decision(120);
decision_align(62) <= decision(121);
decision_align(94) <= decision(122);
decision_align(126) <= decision(123);
decision_align(158) <= decision(124);
decision_align(190) <= decision(125);
decision_align(222) <= decision(126);
decision_align(254) <= decision(127);
decision_align(256) <= decision(128);
decision_align(288) <= decision(129);
decision_align(320) <= decision(130);
decision_align(352) <= decision(131);
decision_align(384) <= decision(132);
decision_align(416) <= decision(133);
decision_align(448) <= decision(134);
decision_align(480) <= decision(135);
decision_align(258) <= decision(136);
decision_align(290) <= decision(137);
decision_align(322) <= decision(138);
decision_align(354) <= decision(139);
decision_align(386) <= decision(140);
decision_align(418) <= decision(141);
decision_align(450) <= decision(142);
decision_align(482) <= decision(143);
decision_align(260) <= decision(144);
decision_align(292) <= decision(145);
decision_align(324) <= decision(146);
decision_align(356) <= decision(147);
decision_align(388) <= decision(148);
decision_align(420) <= decision(149);
decision_align(452) <= decision(150);
decision_align(484) <= decision(151);
decision_align(262) <= decision(152);
decision_align(294) <= decision(153);
decision_align(326) <= decision(154);
decision_align(358) <= decision(155);
decision_align(390) <= decision(156);
decision_align(422) <= decision(157);
decision_align(454) <= decision(158);
decision_align(486) <= decision(159);
decision_align(264) <= decision(160);
decision_align(296) <= decision(161);
decision_align(328) <= decision(162);
decision_align(360) <= decision(163);
decision_align(392) <= decision(164);
decision_align(424) <= decision(165);
decision_align(456) <= decision(166);
decision_align(488) <= decision(167);
decision_align(266) <= decision(168);
decision_align(298) <= decision(169);
decision_align(330) <= decision(170);
decision_align(362) <= decision(171);
decision_align(394) <= decision(172);
decision_align(426) <= decision(173);
decision_align(458) <= decision(174);
decision_align(490) <= decision(175);
decision_align(268) <= decision(176);
decision_align(300) <= decision(177);
decision_align(332) <= decision(178);
decision_align(364) <= decision(179);
decision_align(396) <= decision(180);
decision_align(428) <= decision(181);
decision_align(460) <= decision(182);
decision_align(492) <= decision(183);
decision_align(270) <= decision(184);
decision_align(302) <= decision(185);
decision_align(334) <= decision(186);
decision_align(366) <= decision(187);
decision_align(398) <= decision(188);
decision_align(430) <= decision(189);
decision_align(462) <= decision(190);
decision_align(494) <= decision(191);
decision_align(272) <= decision(192);
decision_align(304) <= decision(193);
decision_align(336) <= decision(194);
decision_align(368) <= decision(195);
decision_align(400) <= decision(196);
decision_align(432) <= decision(197);
decision_align(464) <= decision(198);
decision_align(496) <= decision(199);
decision_align(274) <= decision(200);
decision_align(306) <= decision(201);
decision_align(338) <= decision(202);
decision_align(370) <= decision(203);
decision_align(402) <= decision(204);
decision_align(434) <= decision(205);
decision_align(466) <= decision(206);
decision_align(498) <= decision(207);
decision_align(276) <= decision(208);
decision_align(308) <= decision(209);
decision_align(340) <= decision(210);
decision_align(372) <= decision(211);
decision_align(404) <= decision(212);
decision_align(436) <= decision(213);
decision_align(468) <= decision(214);
decision_align(500) <= decision(215);
decision_align(278) <= decision(216);
decision_align(310) <= decision(217);
decision_align(342) <= decision(218);
decision_align(374) <= decision(219);
decision_align(406) <= decision(220);
decision_align(438) <= decision(221);
decision_align(470) <= decision(222);
decision_align(502) <= decision(223);
decision_align(280) <= decision(224);
decision_align(312) <= decision(225);
decision_align(344) <= decision(226);
decision_align(376) <= decision(227);
decision_align(408) <= decision(228);
decision_align(440) <= decision(229);
decision_align(472) <= decision(230);
decision_align(504) <= decision(231);
decision_align(282) <= decision(232);
decision_align(314) <= decision(233);
decision_align(346) <= decision(234);
decision_align(378) <= decision(235);
decision_align(410) <= decision(236);
decision_align(442) <= decision(237);
decision_align(474) <= decision(238);
decision_align(506) <= decision(239);
decision_align(284) <= decision(240);
decision_align(316) <= decision(241);
decision_align(348) <= decision(242);
decision_align(380) <= decision(243);
decision_align(412) <= decision(244);
decision_align(444) <= decision(245);
decision_align(476) <= decision(246);
decision_align(508) <= decision(247);
decision_align(286) <= decision(248);
decision_align(318) <= decision(249);
decision_align(350) <= decision(250);
decision_align(382) <= decision(251);
decision_align(414) <= decision(252);
decision_align(446) <= decision(253);
decision_align(478) <= decision(254);
decision_align(510) <= decision(255);
decision_align(1) <= decision(256);
decision_align(33) <= decision(257);
decision_align(65) <= decision(258);
decision_align(97) <= decision(259);
decision_align(129) <= decision(260);
decision_align(161) <= decision(261);
decision_align(193) <= decision(262);
decision_align(225) <= decision(263);
decision_align(3) <= decision(264);
decision_align(35) <= decision(265);
decision_align(67) <= decision(266);
decision_align(99) <= decision(267);
decision_align(131) <= decision(268);
decision_align(163) <= decision(269);
decision_align(195) <= decision(270);
decision_align(227) <= decision(271);
decision_align(5) <= decision(272);
decision_align(37) <= decision(273);
decision_align(69) <= decision(274);
decision_align(101) <= decision(275);
decision_align(133) <= decision(276);
decision_align(165) <= decision(277);
decision_align(197) <= decision(278);
decision_align(229) <= decision(279);
decision_align(7) <= decision(280);
decision_align(39) <= decision(281);
decision_align(71) <= decision(282);
decision_align(103) <= decision(283);
decision_align(135) <= decision(284);
decision_align(167) <= decision(285);
decision_align(199) <= decision(286);
decision_align(231) <= decision(287);
decision_align(9) <= decision(288);
decision_align(41) <= decision(289);
decision_align(73) <= decision(290);
decision_align(105) <= decision(291);
decision_align(137) <= decision(292);
decision_align(169) <= decision(293);
decision_align(201) <= decision(294);
decision_align(233) <= decision(295);
decision_align(11) <= decision(296);
decision_align(43) <= decision(297);
decision_align(75) <= decision(298);
decision_align(107) <= decision(299);
decision_align(139) <= decision(300);
decision_align(171) <= decision(301);
decision_align(203) <= decision(302);
decision_align(235) <= decision(303);
decision_align(13) <= decision(304);
decision_align(45) <= decision(305);
decision_align(77) <= decision(306);
decision_align(109) <= decision(307);
decision_align(141) <= decision(308);
decision_align(173) <= decision(309);
decision_align(205) <= decision(310);
decision_align(237) <= decision(311);
decision_align(15) <= decision(312);
decision_align(47) <= decision(313);
decision_align(79) <= decision(314);
decision_align(111) <= decision(315);
decision_align(143) <= decision(316);
decision_align(175) <= decision(317);
decision_align(207) <= decision(318);
decision_align(239) <= decision(319);
decision_align(17) <= decision(320);
decision_align(49) <= decision(321);
decision_align(81) <= decision(322);
decision_align(113) <= decision(323);
decision_align(145) <= decision(324);
decision_align(177) <= decision(325);
decision_align(209) <= decision(326);
decision_align(241) <= decision(327);
decision_align(19) <= decision(328);
decision_align(51) <= decision(329);
decision_align(83) <= decision(330);
decision_align(115) <= decision(331);
decision_align(147) <= decision(332);
decision_align(179) <= decision(333);
decision_align(211) <= decision(334);
decision_align(243) <= decision(335);
decision_align(21) <= decision(336);
decision_align(53) <= decision(337);
decision_align(85) <= decision(338);
decision_align(117) <= decision(339);
decision_align(149) <= decision(340);
decision_align(181) <= decision(341);
decision_align(213) <= decision(342);
decision_align(245) <= decision(343);
decision_align(23) <= decision(344);
decision_align(55) <= decision(345);
decision_align(87) <= decision(346);
decision_align(119) <= decision(347);
decision_align(151) <= decision(348);
decision_align(183) <= decision(349);
decision_align(215) <= decision(350);
decision_align(247) <= decision(351);
decision_align(25) <= decision(352);
decision_align(57) <= decision(353);
decision_align(89) <= decision(354);
decision_align(121) <= decision(355);
decision_align(153) <= decision(356);
decision_align(185) <= decision(357);
decision_align(217) <= decision(358);
decision_align(249) <= decision(359);
decision_align(27) <= decision(360);
decision_align(59) <= decision(361);
decision_align(91) <= decision(362);
decision_align(123) <= decision(363);
decision_align(155) <= decision(364);
decision_align(187) <= decision(365);
decision_align(219) <= decision(366);
decision_align(251) <= decision(367);
decision_align(29) <= decision(368);
decision_align(61) <= decision(369);
decision_align(93) <= decision(370);
decision_align(125) <= decision(371);
decision_align(157) <= decision(372);
decision_align(189) <= decision(373);
decision_align(221) <= decision(374);
decision_align(253) <= decision(375);
decision_align(31) <= decision(376);
decision_align(63) <= decision(377);
decision_align(95) <= decision(378);
decision_align(127) <= decision(379);
decision_align(159) <= decision(380);
decision_align(191) <= decision(381);
decision_align(223) <= decision(382);
decision_align(255) <= decision(383);
decision_align(257) <= decision(384);
decision_align(289) <= decision(385);
decision_align(321) <= decision(386);
decision_align(353) <= decision(387);
decision_align(385) <= decision(388);
decision_align(417) <= decision(389);
decision_align(449) <= decision(390);
decision_align(481) <= decision(391);
decision_align(259) <= decision(392);
decision_align(291) <= decision(393);
decision_align(323) <= decision(394);
decision_align(355) <= decision(395);
decision_align(387) <= decision(396);
decision_align(419) <= decision(397);
decision_align(451) <= decision(398);
decision_align(483) <= decision(399);
decision_align(261) <= decision(400);
decision_align(293) <= decision(401);
decision_align(325) <= decision(402);
decision_align(357) <= decision(403);
decision_align(389) <= decision(404);
decision_align(421) <= decision(405);
decision_align(453) <= decision(406);
decision_align(485) <= decision(407);
decision_align(263) <= decision(408);
decision_align(295) <= decision(409);
decision_align(327) <= decision(410);
decision_align(359) <= decision(411);
decision_align(391) <= decision(412);
decision_align(423) <= decision(413);
decision_align(455) <= decision(414);
decision_align(487) <= decision(415);
decision_align(265) <= decision(416);
decision_align(297) <= decision(417);
decision_align(329) <= decision(418);
decision_align(361) <= decision(419);
decision_align(393) <= decision(420);
decision_align(425) <= decision(421);
decision_align(457) <= decision(422);
decision_align(489) <= decision(423);
decision_align(267) <= decision(424);
decision_align(299) <= decision(425);
decision_align(331) <= decision(426);
decision_align(363) <= decision(427);
decision_align(395) <= decision(428);
decision_align(427) <= decision(429);
decision_align(459) <= decision(430);
decision_align(491) <= decision(431);
decision_align(269) <= decision(432);
decision_align(301) <= decision(433);
decision_align(333) <= decision(434);
decision_align(365) <= decision(435);
decision_align(397) <= decision(436);
decision_align(429) <= decision(437);
decision_align(461) <= decision(438);
decision_align(493) <= decision(439);
decision_align(271) <= decision(440);
decision_align(303) <= decision(441);
decision_align(335) <= decision(442);
decision_align(367) <= decision(443);
decision_align(399) <= decision(444);
decision_align(431) <= decision(445);
decision_align(463) <= decision(446);
decision_align(495) <= decision(447);
decision_align(273) <= decision(448);
decision_align(305) <= decision(449);
decision_align(337) <= decision(450);
decision_align(369) <= decision(451);
decision_align(401) <= decision(452);
decision_align(433) <= decision(453);
decision_align(465) <= decision(454);
decision_align(497) <= decision(455);
decision_align(275) <= decision(456);
decision_align(307) <= decision(457);
decision_align(339) <= decision(458);
decision_align(371) <= decision(459);
decision_align(403) <= decision(460);
decision_align(435) <= decision(461);
decision_align(467) <= decision(462);
decision_align(499) <= decision(463);
decision_align(277) <= decision(464);
decision_align(309) <= decision(465);
decision_align(341) <= decision(466);
decision_align(373) <= decision(467);
decision_align(405) <= decision(468);
decision_align(437) <= decision(469);
decision_align(469) <= decision(470);
decision_align(501) <= decision(471);
decision_align(279) <= decision(472);
decision_align(311) <= decision(473);
decision_align(343) <= decision(474);
decision_align(375) <= decision(475);
decision_align(407) <= decision(476);
decision_align(439) <= decision(477);
decision_align(471) <= decision(478);
decision_align(503) <= decision(479);
decision_align(281) <= decision(480);
decision_align(313) <= decision(481);
decision_align(345) <= decision(482);
decision_align(377) <= decision(483);
decision_align(409) <= decision(484);
decision_align(441) <= decision(485);
decision_align(473) <= decision(486);
decision_align(505) <= decision(487);
decision_align(283) <= decision(488);
decision_align(315) <= decision(489);
decision_align(347) <= decision(490);
decision_align(379) <= decision(491);
decision_align(411) <= decision(492);
decision_align(443) <= decision(493);
decision_align(475) <= decision(494);
decision_align(507) <= decision(495);
decision_align(285) <= decision(496);
decision_align(317) <= decision(497);
decision_align(349) <= decision(498);
decision_align(381) <= decision(499);
decision_align(413) <= decision(500);
decision_align(445) <= decision(501);
decision_align(477) <= decision(502);
decision_align(509) <= decision(503);
decision_align(287) <= decision(504);
decision_align(319) <= decision(505);
decision_align(351) <= decision(506);
decision_align(383) <= decision(507);
decision_align(415) <= decision(508);
decision_align(447) <= decision(509);
decision_align(479) <= decision(510);
decision_align(511) <= decision(511);

end rtl;