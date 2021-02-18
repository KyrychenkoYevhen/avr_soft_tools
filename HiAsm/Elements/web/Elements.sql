BEGIN TRANSACTION;
CREATE TABLE groups(id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(64), info varchar(128), pos int);
INSERT INTO "groups" VALUES(1,'Main','��������',1);
INSERT INTO "groups" VALUES(22,'Service','������',6);
INSERT INTO "groups" VALUES(23,'LowLevel','���������',12);
INSERT INTO "groups" VALUES(24,'Strings','������',8);
INSERT INTO "groups" VALUES(26,'Helpers','���������',14);
INSERT INTO "groups" VALUES(27,'Html','Html',4);
INSERT INTO "groups" VALUES(28,'',NULL,10);
INSERT INTO "groups" VALUES(30,'JavaScript','JavaScript',3);
INSERT INTO "groups" VALUES(33,'Arrays','�������',11);
INSERT INTO "groups" VALUES(34,'PHP','PHP',2);
INSERT INTO "groups" VALUES(35,'CodeGen','�������������',13);
INSERT INTO "groups" VALUES(36,'SiteBuilder','��������������',15);
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('groups',36);
INSERT INTO "sqlite_sequence" VALUES('elements',283);
CREATE TABLE elements(id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(64), info varchar(64), tab int, pos int, hash varchar(32));
INSERT INTO "elements" VALUES(1,'EntryPoint','����� �����',28,1,'EA51A259526D5A137360B5980FA30F6E');
INSERT INTO "elements" VALUES(2,'Echo','����� ������',22,3,'B4645BBAE0018C60AB02C65FC95AC030');
INSERT INTO "elements" VALUES(3,'For','����',1,14,'2D741038C2C5B490737B327D9448C437');
INSERT INTO "elements" VALUES(4,'If_else','�������',1,12,'500300172D5F1F71B33166A1D3C23B35');
INSERT INTO "elements" VALUES(5,'InfoTip','�������',26,9,'');
INSERT INTO "elements" VALUES(6,'LineBreak','������ �����',26,3,'');
INSERT INTO "elements" VALUES(7,'Shape','������',26,11,'');
INSERT INTO "elements" VALUES(8,'StrCat','����������� �����',24,1,'A1D719AB228A9FC0B95923290ACAF553');
INSERT INTO "elements" VALUES(9,'Length','������ ������',24,2,'44756E8D925792BB21AA092832ACAE99');
INSERT INTO "elements" VALUES(10,'Position','������� � ������',24,3,'9B3E8A1EBB0EC2214F6A78B314CC9390');
INSERT INTO "elements" VALUES(11,'Session','������',34,33,'AEF8FCA481A9E98D0771089D51B46ADF');
INSERT INTO "elements" VALUES(12,'DoData','�����-������',1,18,'FEC38F6278DE28DA76AC7DCC3E1198A7');
INSERT INTO "elements" VALUES(13,'Hub','���',1,17,'4A4C56C2C643BFE934B82913D447E5EE');
INSERT INTO "elements" VALUES(14,'Math','����������',1,2,'4E50FCFFDC33FB1F138C2F70B5779FDB');
INSERT INTO "elements" VALUES(15,'Memory','������',1,19,'9281280A9C055FE1B1A9756450F0E7D9');
INSERT INTO "elements" VALUES(16,'HTM_Html','��� <html>',27,2,'6D5159F2E18ED8B879F488A8891D3053');
INSERT INTO "elements" VALUES(17,'HTM_Head','��� <head>',27,3,'C4EC1A3C6C954B14253E5FE86BB95981');
INSERT INTO "elements" VALUES(18,'HTM_Body','��� <body>',27,4,'F8C00309B3B40BD4CB940A07D7ECB2B0');
INSERT INTO "elements" VALUES(19,'LinkTip','������',26,10,'');
INSERT INTO "elements" VALUES(20,'HTM_Form','�����',27,30,'4750B149A1E258AF3872821FE5063D29');
INSERT INTO "elements" VALUES(21,'HTM_Edit','���� �����',27,31,'EF98B14B6073630B41ACC95720A8F2A1');
INSERT INTO "elements" VALUES(22,'HTM_Submit','��������',27,32,'0E2345C85E75DCBCE063DF154E00E0C5');
INSERT INTO "elements" VALUES(23,'HTM_Checkbox','������',27,33,'041CB2E321653237D741FE4CA4DCD408');
INSERT INTO "elements" VALUES(24,'HTM_Hidden','������� ����',27,39,'4B4C1C49E2236AB44BE02339A5619C18');
INSERT INTO "elements" VALUES(25,'HTM_File','����',27,34,'037CD83674EB7FDA7BA903DBA7DEF08A');
INSERT INTO "elements" VALUES(26,'HTM_Select','������',27,35,'097E9B3F797BA09BAB97E9B3054707C8');
INSERT INTO "elements" VALUES(27,'HTM_Option','������� ������',27,36,'A3DBFB4688F4543A0EDE16A9D39B880C');
INSERT INTO "elements" VALUES(28,'HTM_Textarea','��������� ����',27,37,'ABAAB476B683380E213414E5ACD901CB');
INSERT INTO "elements" VALUES(29,'HTM_Radio','�������������',27,38,'06994C3507A76C5C1C84288205554DFA');
INSERT INTO "elements" VALUES(30,'Vars','����������',34,44,'5E625C01F8CE7ECFF0EA77DB8A514A73');
INSERT INTO "elements" VALUES(31,'HTM_Table','��� <table>',27,22,'012F3798DB52D39617D4C67EB5D78FEF');
INSERT INTO "elements" VALUES(32,'HTM_Tr','��� <tr>',27,24,'873FC19115A925B8892DA548A9D24CFC');
INSERT INTO "elements" VALUES(33,'HTM_Td','��� <td>',27,25,'3668B40827FCF2C12934301F1A8DB344');
INSERT INTO "elements" VALUES(34,'HTM_Title','��� <title>',27,5,'4F933C76ABEF5069F8309110E619F9C9');
INSERT INTO "elements" VALUES(35,'FileTools','�������� ��������',34,16,'6990EC634392C4EF3BFDEFEAF582E9C9');
INSERT INTO "elements" VALUES(36,'File','����',34,17,'3D11EF4C4C0360DE9ECC994E6CA44D83');
INSERT INTO "elements" VALUES(38,'HTM_FrameSet','��� <frameset>',27,6,'7A3BA400CE54E0D4D74EDBCF31AB5BC6');
INSERT INTO "elements" VALUES(39,'HTM_Frame','��� <frame>',27,7,'DB7B17C363EAC1034464DF06096A5C5E');
INSERT INTO "elements" VALUES(40,'HubEx','����',26,4,'');
INSERT INTO "elements" VALUES(41,'GetDataEx','����',26,5,'');
INSERT INTO "elements" VALUES(42,'HTM_Meta','��� <meta>',27,8,'EDF9BDFAF46AD8ECFD62AD06D94FCDAF');
INSERT INTO "elements" VALUES(43,'PhpInfo','���������� � PHP',34,38,'AEAD755601C4EDFC148C6F9928E69615');
INSERT INTO "elements" VALUES(44,'HTM_Style','��� <style>',27,9,'3D67115D8005091D597702699816DC4C');
INSERT INTO "elements" VALUES(45,'CSS','CSS �����',27,10,'CD37E2124E362F62626DC8BF2E86D4D6');
INSERT INTO "elements" VALUES(46,'FileSearch','����� ������',34,18,'24C2D43170CCC40C03BE2B16628C51D5');
INSERT INTO "elements" VALUES(47,'FormatTime','������ �������',22,2,'09B7AB2EA41C6E3790522E94ED2C63F0');
INSERT INTO "elements" VALUES(48,'HTM_A','��� <a>',27,11,'DC2B56BC6AA0CE548A58A30EA5BE3452');
INSERT INTO "elements" VALUES(49,'HTM_Div','��� <div>',27,12,'2E5A478A4B4A44559CC67C7C915D2AB5');
INSERT INTO "elements" VALUES(50,'HTM_Span','��� <span>',27,13,'97DD5AC3D1CE6D7E66A0754D8D6E5E97');
INSERT INTO "elements" VALUES(51,'GetTok','��������� ������',34,2,'51AFDF03E82BE365D6AC78F8A1086907');
INSERT INTO "elements" VALUES(52,'HTM_P','��� <p>',27,14,'F74861FEDC481C9AC1B7A6954DB4DCBD');
INSERT INTO "elements" VALUES(53,'HtmlEntryPoint','����� ����� HTML',28,2,'1AC819D78D9BCC203C003572F9BE172B');
INSERT INTO "elements" VALUES(54,'HTM_Script','��� <script>',27,18,'16AC14F929E680F972893832457451DD');
INSERT INTO "elements" VALUES(55,'HTM_List','��� <ul> � <ol>',27,15,'CDBA2CC9AD16C116F21493DD641D54C6');
INSERT INTO "elements" VALUES(56,'HTM_Li','��� <li>',27,16,'9BCDE775159F7F6467CB642115CDBB7D');
INSERT INTO "elements" VALUES(57,'HTM_Img','��� <img>',27,17,'79E0AFD50F490834BAF1047931F20CE1');
INSERT INTO "elements" VALUES(58,'Inline','����� ����',23,5,'D03E4B5EC76D5C9D28227F91381B989C');
INSERT INTO "elements" VALUES(59,'MouseEvent','����',30,1,'');
INSERT INTO "elements" VALUES(60,'Timer','������',30,6,'');
INSERT INTO "elements" VALUES(61,'FormatStr','��������������� ������',24,5,'');
INSERT INTO "elements" VALUES(62,'Function','�������',23,4,'');
INSERT INTO "elements" VALUES(63,'CallFunc','����� �-���',23,3,'');
INSERT INTO "elements" VALUES(64,'GetElementById','������ � �������',30,24,'');
INSERT INTO "elements" VALUES(65,'MathParse','���. ���������',1,5,'');
INSERT INTO "elements" VALUES(66,'CSSEntryPoint','����� ����� CSS',28,3,'');
INSERT INTO "elements" VALUES(67,'JavaEntryPoint','����� ����� Java',28,4,'');
INSERT INTO "elements" VALUES(68,'VisualInline','������� ����',23,6,'');
INSERT INTO "elements" VALUES(69,'VisualText','������� ������',1,20,'');
INSERT INTO "elements" VALUES(70,'GlobalVar','���������� ����������',1,8,'');
INSERT INTO "elements" VALUES(71,'mysql_connect','���������� � MySQL',34,26,'');
INSERT INTO "elements" VALUES(72,'mysql_num_rows','���������� ����� � �������',34,28,'');
INSERT INTO "elements" VALUES(73,'mysql_query','������ � ����',34,27,'');
INSERT INTO "elements" VALUES(74,'SDKBtn','������ �� ������� �����',26,17,'');
INSERT INTO "elements" VALUES(75,'mysql_fetch_array','������',34,30,'');
INSERT INTO "elements" VALUES(76,'ArrayItem','������ � �������',33,1,'');
INSERT INTO "elements" VALUES(77,'Include','������� ����',34,39,'');
INSERT INTO "elements" VALUES(78,'Die','���������� ������',34,40,'');
INSERT INTO "elements" VALUES(79,'Replace','������',24,6,'');
INSERT INTO "elements" VALUES(80,'Case','����� ��������',1,13,'');
INSERT INTO "elements" VALUES(81,'HTML_Collector','������� HTML',27,52,'');
INSERT INTO "elements" VALUES(82,'CustomCode','���������������� �������',35,1,'');
INSERT INTO "elements" VALUES(83,'MultiElement','��������� �����',1,9,'');
INSERT INTO "elements" VALUES(84,'EditMulti','�������� ���������� ����������',28,6,'');
INSERT INTO "elements" VALUES(85,'HCEditor','�������� HTML_Collector',28,7,'');
INSERT INTO "elements" VALUES(86,'MultiElementEx','��������� �����',1,10,'');
INSERT INTO "elements" VALUES(87,'EditMultiEx','�������� ���������� MultiElementEx',28,8,'');
INSERT INTO "elements" VALUES(88,'PointElement','�����',28,9,'');
INSERT INTO "elements" VALUES(89,'mysql_result','��������� �������',34,29,'');
INSERT INTO "elements" VALUES(90,'IsSet','�������� ����������',34,41,'');
INSERT INTO "elements" VALUES(91,'*Html_����','����',27,1,'');
INSERT INTO "elements" VALUES(92,'*Html_�����','�����',27,29,'');
INSERT INTO "elements" VALUES(93,'*Html_������','������',27,51,'');
INSERT INTO "elements" VALUES(94,'*PHP_MySQL','MySQL',34,25,'');
INSERT INTO "elements" VALUES(95,'*PHP_������','������',34,37,'');
INSERT INTO "elements" VALUES(96,'*PHP_�����','�����',34,15,'');
INSERT INTO "elements" VALUES(97,'*PHP_������','������',34,32,'');
INSERT INTO "elements" VALUES(98,'*Helpers_�����','�����',26,1,'');
INSERT INTO "elements" VALUES(99,'*Helpers_������','������',26,8,'');
INSERT INTO "elements" VALUES(100,'*Helpers_�����','�����',26,16,'');
INSERT INTO "elements" VALUES(101,'AccessFTP','������ � FTP',26,18,'');
INSERT INTO "elements" VALUES(102,'SessionVar','���������� ������',34,34,'');
INSERT INTO "elements" VALUES(103,'SessionSavePath','������� ������',34,35,'');
INSERT INTO "elements" VALUES(104,'Header','����������� HTTP ���������',34,43,'');
INSERT INTO "elements" VALUES(105,'ArrayEnum','������� �������',33,2,'');
INSERT INTO "elements" VALUES(106,'ArrayRead','������ �������',33,3,'');
INSERT INTO "elements" VALUES(107,'ArraySize','������ �������',33,4,'');
INSERT INTO "elements" VALUES(108,'ArraySplit','�������� ������',24,9,'');
INSERT INTO "elements" VALUES(109,'ArrayWrite','������ � ������',33,5,'');
INSERT INTO "elements" VALUES(110,'History','������� ���������',30,8,'');
INSERT INTO "elements" VALUES(111,'XMLHttpRequest','������ �� ������',30,7,'');
INSERT INTO "elements" VALUES(112,'*JavaScript_�������','�������',30,5,'');
INSERT INTO "elements" VALUES(113,'mysql_fetch_row','��������������� ������',34,31,'');
INSERT INTO "elements" VALUES(114,'FileWrite','������ � ����',34,19,'');
INSERT INTO "elements" VALUES(115,'FileRead','������ �� �����',34,20,'');
INSERT INTO "elements" VALUES(116,'StringBuilder','����������� ������',24,7,'');
INSERT INTO "elements" VALUES(117,'*PHP_������','������',34,1,'');
INSERT INTO "elements" VALUES(118,'md5','��������� md5 ����',34,4,'');
INSERT INTO "elements" VALUES(119,'JavaScript_Collector','������� JavaScript',27,53,'');
INSERT INTO "elements" VALUES(120,'AddSlashes','������������� ���� ������',34,3,'');
INSERT INTO "elements" VALUES(121,'HtmlSpecialChars','������������� ���� ������ HTML',34,5,'');
INSERT INTO "elements" VALUES(122,'FileArray','�������� � ������',34,21,'');
INSERT INTO "elements" VALUES(123,'StrArray','������ �����',33,6,'');
INSERT INTO "elements" VALUES(124,'HTM_Tag','��� HTML',28,10,'');
INSERT INTO "elements" VALUES(125,'HTM_DoubleTag','������� ��� HTML',28,11,'');
INSERT INTO "elements" VALUES(126,'HTM_SimpleTag','��������� ��� HTML',28,12,'');
INSERT INTO "elements" VALUES(127,'IntArray','������ �����',33,7,'');
INSERT INTO "elements" VALUES(128,'HTM_Th','��� <th>',27,23,'');
INSERT INTO "elements" VALUES(129,'HTM_Thead','��� <thead>',27,26,'');
INSERT INTO "elements" VALUES(130,'HTM_Tfoot','��� <tfoot>',27,28,'');
INSERT INTO "elements" VALUES(131,'HTM_Tbody','��� <tbody>',27,27,'');
INSERT INTO "elements" VALUES(132,'*Html_�������','�������',27,21,'');
INSERT INTO "elements" VALUES(133,'Debug','�������',26,2,'');
INSERT INTO "elements" VALUES(134,'*Main_������','������',1,11,'');
INSERT INTO "elements" VALUES(135,'*Main_�����������','�����������',1,16,'');
INSERT INTO "elements" VALUES(136,'Confirm','�������������',30,9,'');
INSERT INTO "elements" VALUES(137,'Prompt','���� ������',30,10,'');
INSERT INTO "elements" VALUES(138,'Window','����',30,11,'');
INSERT INTO "elements" VALUES(139,'CG_BlockPrint','����� �����',35,8,'');
INSERT INTO "elements" VALUES(140,'CG_LevelControl','�������� ������',35,2,'');
INSERT INTO "elements" VALUES(141,'*CodeGen_�����','�����',35,7,'');
INSERT INTO "elements" VALUES(142,'CG_BlockReg','����������� �����',35,9,'');
INSERT INTO "elements" VALUES(143,'CG_BlockSelect','����� �����',35,10,'');
INSERT INTO "elements" VALUES(144,'CG_BlockDelete','�������� �����',35,11,'');
INSERT INTO "elements" VALUES(145,'CG_Trace','�������',35,3,'');
INSERT INTO "elements" VALUES(146,'Escape','��������� UTF8',30,18,'');
INSERT INTO "elements" VALUES(147,'Cookie','������',30,12,'');
INSERT INTO "elements" VALUES(148,'*JavaScript_������','������',30,17,'');
INSERT INTO "elements" VALUES(149,'CG_BlockIncLevel','���������� �������',35,13,'');
INSERT INTO "elements" VALUES(150,'CG_BlockDecLevel','���������� �������',35,14,'');
INSERT INTO "elements" VALUES(151,'Eval','����������',30,2,'');
INSERT INTO "elements" VALUES(152,'ASort','���������� �������',33,8,'');
INSERT INTO "elements" VALUES(153,'Random','��������� �����',30,4,'');
INSERT INTO "elements" VALUES(154,'Rand','��������� �����',34,47,'');
INSERT INTO "elements" VALUES(155,'HexDec','����������������� � ����������',34,6,'');
INSERT INTO "elements" VALUES(156,'DecHex','���������� � �����������������',34,7,'');
INSERT INTO "elements" VALUES(157,'Chop','�������� ��������',34,8,'');
INSERT INTO "elements" VALUES(158,'ChunkSplit','��������� ������',34,10,'');
INSERT INTO "elements" VALUES(159,'ConvertCyrString','����� ���������',34,14,'');
INSERT INTO "elements" VALUES(160,'Flush','����� ������',34,48,'');
INSERT INTO "elements" VALUES(161,'Trim','�������� ��������',34,11,'');
INSERT INTO "elements" VALUES(162,'nl2br','������ �������� ������',34,12,'');
INSERT INTO "elements" VALUES(163,'Soundex','���� soundex',34,13,'');
INSERT INTO "elements" VALUES(164,'Socket','�����',34,22,'');
INSERT INTO "elements" VALUES(165,'HostByAddr','��� ����� �� IP',34,46,'');
INSERT INTO "elements" VALUES(166,'DirTools','�������� � ����������',34,23,'');
INSERT INTO "elements" VALUES(167,'EncodeURI','URI-�o��po�a��e',30,19,'');
INSERT INTO "elements" VALUES(168,'StrInt','C�po�a � ��c�o',24,8,'');
INSERT INTO "elements" VALUES(169,'Return','�������',23,7,'');
INSERT INTO "elements" VALUES(170,'IndexToChanel','������ � �����',1,22,'');
INSERT INTO "elements" VALUES(171,'ChangeMon','���������� ��������� ������',1,23,'');
INSERT INTO "elements" VALUES(172,'SampleDelta','�������� �������',1,24,'');
INSERT INTO "elements" VALUES(173,'ChanelToIndex','����� � ������',1,21,'');
INSERT INTO "elements" VALUES(174,'Field','����',23,8,'');
INSERT INTO "elements" VALUES(175,'HTM_Br','��� <br>',27,19,'');
INSERT INTO "elements" VALUES(176,'HTM_Label','��� <label>',27,20,'');
INSERT INTO "elements" VALUES(177,'CG_HiAsmVersion','������ HiAsm',35,4,'');
INSERT INTO "elements" VALUES(178,'CG_BuildTime','����� ������',35,5,'');
INSERT INTO "elements" VALUES(179,'Check','������',26,7,'');
INSERT INTO "elements" VALUES(180,'ScriptEvents','������� �������',26,19,'');
INSERT INTO "elements" VALUES(181,'PointHint','������',26,13,'');
INSERT INTO "elements" VALUES(182,'PictureTip','����������� �������� � ��������� ���������',26,12,'');
INSERT INTO "elements" VALUES(183,'ImageMulti','����������� ���� � ���������',26,14,'');
INSERT INTO "elements" VALUES(184,'ViewSHA','����������� ���� � ���������',26,15,'');
INSERT INTO "elements" VALUES(185,'Match','����� ������������',30,20,'');
INSERT INTO "elements" VALUES(186,'TAG_InnerHTML','��������� ������ HTML',30,25,'');
INSERT INTO "elements" VALUES(187,'TAG_ControlValue','��������� �������� ��������',30,26,'');
INSERT INTO "elements" VALUES(188,'TAG_Position','������� ��������',30,27,'');
INSERT INTO "elements" VALUES(189,'TAG_SetStyle','��������� �����',30,28,'');
INSERT INTO "elements" VALUES(190,'*JavaScript_����','����',30,23,'');
INSERT INTO "elements" VALUES(191,'While','���� � ��������',1,15,'');
INSERT INTO "elements" VALUES(192,'*Html_WML','WML',27,40,'');
INSERT INTO "elements" VALUES(193,'HTM_Go','��� <Go>',27,41,'');
INSERT INTO "elements" VALUES(194,'HTM_Access','��� <Access>',27,42,'');
INSERT INTO "elements" VALUES(195,'HTM_Anchor','��� <Anchor>',27,43,'');
INSERT INTO "elements" VALUES(196,'HTM_Card','��� <Card>',27,44,'');
INSERT INTO "elements" VALUES(197,'HTM_Do','��� <Do>',27,45,'');
INSERT INTO "elements" VALUES(198,'HTM_Onevent','��� <Onevent>',27,46,'');
INSERT INTO "elements" VALUES(199,'HTM_Optgroupe','��� <Optgroupe>',27,47,'');
INSERT INTO "elements" VALUES(200,'HTM_Postfield','��� <Postfield>',27,48,'');
INSERT INTO "elements" VALUES(201,'HTM_Setvar','��� <Setvar>',27,49,'');
INSERT INTO "elements" VALUES(202,'HTM_Wml','��� <wml>',27,50,'');
INSERT INTO "elements" VALUES(203,'Document','��������',30,13,'');
INSERT INTO "elements" VALUES(204,'TextRange','��������� ��������',30,14,'');
INSERT INTO "elements" VALUES(205,'Flash','������� ���� �� ��������',27,51,'');
INSERT INTO "elements" VALUES(206,'Copy','�����������',24,10,'');
INSERT INTO "elements" VALUES(207,'StrCase','�������',24,11,'');
INSERT INTO "elements" VALUES(208,'SessionCookie','��������� ������',34,36,'');
INSERT INTO "elements" VALUES(209,'PregReplaceCallback','������ ���������',34,50,'');
INSERT INTO "elements" VALUES(210,'*PHP_����','����',34,49,'');
INSERT INTO "elements" VALUES(211,'CharAt','������ � ��������',30,21,'');
INSERT INTO "elements" VALUES(212,'PregReplace','������ ���������',34,51,'');
INSERT INTO "elements" VALUES(213,'feof','����� �����',34,24,'');
INSERT INTO "elements" VALUES(214,'TAG_Splitter','��������',30,29,'');
INSERT INTO "elements" VALUES(215,'appendChild','���������� ����',30,31,'');
INSERT INTO "elements" VALUES(216,'*JavaScript_DOM','DOM',30,30,'');
INSERT INTO "elements" VALUES(217,'removeChild','�������� ����',30,32,'');
INSERT INTO "elements" VALUES(218,'replaceChild','��������� �����',30,33,'');
INSERT INTO "elements" VALUES(219,'firstChild','������ �������',30,34,'');
INSERT INTO "elements" VALUES(220,'lastChild','��������� �������',30,35,'');
INSERT INTO "elements" VALUES(221,'parentNode','��������',30,36,'');
INSERT INTO "elements" VALUES(222,'insertBefore','������� ����',30,37,'');
INSERT INTO "elements" VALUES(223,'CreateElement','�������� ����',30,38,'');
INSERT INTO "elements" VALUES(224,'childNodes','������ ���������',30,39,'');
INSERT INTO "elements" VALUES(225,'CreateFunction','�������� �������',30,15,'');
INSERT INTO "elements" VALUES(226,'FuncBody','�������� HTML_Collector',28,13,'');
INSERT INTO "elements" VALUES(227,'GD_Start','GD �������',34,53,'');
INSERT INTO "elements" VALUES(228,'GD_Text','����� ������',34,54,'');
INSERT INTO "elements" VALUES(229,'*PHP_GD','GD',34,52,'');
INSERT INTO "elements" VALUES(230,'GD_Colour','����',34,55,'');
INSERT INTO "elements" VALUES(231,'GD_Fill','������� �������',34,56,'');
INSERT INTO "elements" VALUES(232,'GD_FilledRectangle','����������� ������',34,57,'');
INSERT INTO "elements" VALUES(233,'PointXY','����� (X,Y)',34,58,'');
INSERT INTO "elements" VALUES(234,'CloneNode','������������ ����',30,40,'');
INSERT INTO "elements" VALUES(235,'FieldRead','������ ����',23,9,'');
INSERT INTO "elements" VALUES(236,'StyleSheet','������� ������',30,16,'');
INSERT INTO "elements" VALUES(237,'RegExp','���������� ���������',30,22,'');
INSERT INTO "elements" VALUES(238,'CG_IDController','���������� ID',35,6,'');
INSERT INTO "elements" VALUES(239,'BugReport','���� ������ � ����� � � ���������',26,20,NULL);
INSERT INTO "elements" VALUES(240,'DataManager','������ � �������',36,1,NULL);
INSERT INTO "elements" VALUES(241,'SiteMenu','���� �����',36,2,NULL);
INSERT INTO "elements" VALUES(242,'HintManager','����������� ���������',36,3,NULL);
INSERT INTO "elements" VALUES(243,'BbCode','������ ����� bbcode',36,4,NULL);
INSERT INTO "elements" VALUES(244,'*SiteBuilder_Controls','Controls',36,14,NULL);
INSERT INTO "elements" VALUES(245,'DM_Edit','�������������� ��������� ������',36,17,NULL);
INSERT INTO "elements" VALUES(246,'DM_ComboBox','���������� ������',36,18,NULL);
INSERT INTO "elements" VALUES(247,'DM_Ruller','�������',36,22,NULL);
INSERT INTO "elements" VALUES(248,'DM_CheckBox','������',36,20,NULL);
INSERT INTO "elements" VALUES(250,'DM_Memo','�������������� ������������� ��������� ������',36,24,NULL);
INSERT INTO "elements" VALUES(251,'DM_Label','����������� ������',36,15,NULL);
INSERT INTO "elements" VALUES(252,'DM_Anchor','��������� �� ��������',36,23,NULL);
INSERT INTO "elements" VALUES(253,'DM_Button','������ ���������� �������',36,16,NULL);
INSERT INTO "elements" VALUES(254,'DM_List','������ ������',36,21,NULL);
INSERT INTO "elements" VALUES(255,'*SiteBuilder_DataSource','DataSource',36,9,NULL);
INSERT INTO "elements" VALUES(256,'DS_MySQL','���� ������ MySQL',36,10,NULL);
INSERT INTO "elements" VALUES(257,'DS_StaticData','����������� ������',36,11,NULL);
INSERT INTO "elements" VALUES(258,'DS_FileSystem','�������� �������',36,12,NULL);
INSERT INTO "elements" VALUES(259,'LoginManager','�����������',36,5,NULL);
INSERT INTO "elements" VALUES(260,'AccessManager','�������� �������',36,6,NULL);
INSERT INTO "elements" VALUES(261,'SearchManager','�������� ������',36,7,NULL);
INSERT INTO "elements" VALUES(262,'DS_MSSQL','���� ������ MSSQL',36,13,NULL);
INSERT INTO "elements" VALUES(263,'*PHP_MSSQL','MSSQL',34,59,NULL);
INSERT INTO "elements" VALUES(264,'mssql_connect','���������� � MSSQL',34,60,NULL);
INSERT INTO "elements" VALUES(265,'mssql_query','������ � ����',34,61,NULL);
INSERT INTO "elements" VALUES(266,'FileChecker','�������� �����',36,8,NULL);
INSERT INTO "elements" VALUES(267,'*PHP_cURL','cURL',34,62,NULL);
INSERT INTO "elements" VALUES(268,'cURL','������ cURL',34,63,NULL);
INSERT INTO "elements" VALUES(269,'cURL_Option','��������� ���������� cURL-������',34,64,NULL);
INSERT INTO "elements" VALUES(270,'curl_setopt','��������� ���������� cURL-������',34,65,NULL);
INSERT INTO "elements" VALUES(271,'cURL_exec','���������� cURL ������',34,66,NULL);
INSERT INTO "elements" VALUES(272,'cURL_getinfo','��������� ���������� � ���������� ���������� ������',34,67,NULL);
INSERT INTO "elements" VALUES(273,'Implode','���������� ������� � ������',24,12,NULL);
INSERT INTO "elements" VALUES(274,'SelectText','���������� �����',30,41,NULL);
INSERT INTO "elements" VALUES(276,'*PHP_Postgres','Postgres',34,68,NULL);
INSERT INTO "elements" VALUES(277,'PG_Connect','���������� � �����',34,69,NULL);
INSERT INTO "elements" VALUES(278,'PG_Query','������ � ����',34,70,NULL);
INSERT INTO "elements" VALUES(279,'PG_EnumResult','��������� ����������',34,71,NULL);
INSERT INTO "elements" VALUES(280,'PG_CellResult','��������� ����������',34,72,NULL);
INSERT INTO "elements" VALUES(281,'PG_RowsCount','���������� �����',34,73,NULL);
INSERT INTO "elements" VALUES(282,'TimeCounter','������� �������',1,25,NULL);
INSERT INTO "elements" VALUES(283,'ProtectVar','���������� ����������',34,45,NULL);
CREATE TABLE files(id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(128), count int);
CREATE TABLE files_link(file_id int, el_id int);
COMMIT;