BEGIN TRANSACTION;
CREATE TABLE groups(id INTEGER PRIMARY KEY AUTOINCREMENT,name varchar(64),info varchar(128),pos int);
INSERT INTO "groups" VALUES(1,'WinControls','���������',1);
INSERT INTO "groups" VALUES(2,'Controls','��������',2);
INSERT INTO "groups" VALUES(3,'Graphics','�������',3);
INSERT INTO "groups" VALUES(4,'Windows','����',4);
INSERT INTO "groups" VALUES(5,'System','�������',5);
INSERT INTO "groups" VALUES(6,'Internet','��������',9);
INSERT INTO "groups" VALUES(7,'DataBase','���� ������',10);
INSERT INTO "groups" VALUES(8,'Files','�����',11);
INSERT INTO "groups" VALUES(9,'Logic','������',12);
INSERT INTO "groups" VALUES(10,'Arrays','�������',13);
INSERT INTO "groups" VALUES(11,'Tools','�����������',14);
INSERT INTO "groups" VALUES(12,'LowLevel','���������',18);
INSERT INTO "groups" VALUES(13,'Strings','������',8);
INSERT INTO "groups" VALUES(14,'Consts','���������',17);
INSERT INTO "groups" VALUES(15,'Helpers','���������',16);
INSERT INTO "groups" VALUES(16,'',NULL,19);
INSERT INTO "groups" VALUES(17,'CodeGen','�������������',20);
INSERT INTO "groups" VALUES(18,'Media','�����������',7);
INSERT INTO "groups" VALUES(19,'WMI','�����������������',6);
INSERT INTO "groups" VALUES(20,'MultiThread','�� ������',15);
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('groups',20);
INSERT INTO "sqlite_sequence" VALUES('elements',292);
CREATE TABLE elements(id INTEGER PRIMARY KEY AUTOINCREMENT,name varchar(64),info varchar(64),tab int,pos int,hash varchar(32));
INSERT INTO "elements" VALUES(1,'Label','�������',1,1,NULL);
INSERT INTO "elements" VALUES(2,'CheckBox','������',1,2,NULL);
INSERT INTO "elements" VALUES(3,'RadioButton','�������������',1,3,NULL);
INSERT INTO "elements" VALUES(4,'Button','������',1,4,NULL);
INSERT INTO "elements" VALUES(5,'Edit','���� ������',1,5,NULL);
INSERT INTO "elements" VALUES(6,'ComboBox','���������� ������',1,6,NULL);
INSERT INTO "elements" VALUES(7,'RichEdit','����������� ��������',1,7,NULL);
INSERT INTO "elements" VALUES(8,'StringTable','������� �����',1,8,NULL);
INSERT INTO "elements" VALUES(9,'Calendar','���������',1,9,NULL);
INSERT INTO "elements" VALUES(10,'DatePicker','���������� ���������',1,10,NULL);
INSERT INTO "elements" VALUES(11,'Image','�����������',1,11,NULL);
INSERT INTO "elements" VALUES(12,'WebBrowser','������������ ���������',1,12,NULL);
INSERT INTO "elements" VALUES(13,'Menu','������ ����',1,13,NULL);
INSERT INTO "elements" VALUES(14,'StatusBar','������ �������',1,14,NULL);
INSERT INTO "elements" VALUES(15,'PopupMenu','����������� ����',1,15,NULL);
INSERT INTO "elements" VALUES(16,'ListBox','���co� �����',1,16,NULL);
INSERT INTO "elements" VALUES(17,'ProgressBar','������ ��������',1,17,NULL);
INSERT INTO "elements" VALUES(18,'ScrollBar','������ ���������',1,18,NULL);
INSERT INTO "elements" VALUES(19,'TrackBar','�������� ������',1,19,NULL);
INSERT INTO "elements" VALUES(20,'UpDown','������� �����������',1,20,NULL);
INSERT INTO "elements" VALUES(21,'IPAddress','�������� IP ������',1,21,NULL);
INSERT INTO "elements" VALUES(22,'HyperLink','�����������',1,22,NULL);
INSERT INTO "elements" VALUES(23,'Animate','�������������',1,23,NULL);
INSERT INTO "elements" VALUES(24,'HotKey','������� �������',1,24,NULL);
INSERT INTO "elements" VALUES(25,'ListView','������������� ������',1,25,NULL);
INSERT INTO "elements" VALUES(26,'TreeView','������ ���������',1,26,NULL);
INSERT INTO "elements" VALUES(27,'Splitter','��������� �������� ���������',1,27,NULL);
INSERT INTO "elements" VALUES(28,'HeaderView','��������� �������',1,28,NULL);
INSERT INTO "elements" VALUES(29,'ToolBar','������ ������',1,29,NULL);
INSERT INTO "elements" VALUES(30,'*Interface_�������','�������',1,30,NULL);
INSERT INTO "elements" VALUES(31,'FontDialog','����� ������',1,31,NULL);
INSERT INTO "elements" VALUES(32,'ColorDialog','����� �����',1,32,NULL);
INSERT INTO "elements" VALUES(33,'FindDialog','����� � ������ ������',1,33,NULL);
INSERT INTO "elements" VALUES(34,'PageSetupDialog','��������� ��������',1,34,NULL);
INSERT INTO "elements" VALUES(35,'PrintDialog','������ ������',1,35,NULL);
INSERT INTO "elements" VALUES(36,'*Interface_����������','����������',1,36,NULL);
INSERT INTO "elements" VALUES(37,'ContainerChildForm','�������� �����',1,37,NULL);
INSERT INTO "elements" VALUES(38,'ContainerDialogForm','�������� ���������� �����',1,38,NULL);
INSERT INTO "elements" VALUES(39,'ChildPanel','������',1,39,NULL);
INSERT INTO "elements" VALUES(40,'ChildPanelEx','������',1,40,NULL);
INSERT INTO "elements" VALUES(41,'ChildGroupBox','������ ���������',1,41,NULL);
INSERT INTO "elements" VALUES(42,'ChildGroupBoxEx','������ ���������',1,42,NULL);
INSERT INTO "elements" VALUES(43,'ChildReBar','���������',1,43,NULL);
INSERT INTO "elements" VALUES(44,'ChildPager','���������',1,44,NULL);
INSERT INTO "elements" VALUES(45,'ChildTab','���������',1,45,NULL);
INSERT INTO "elements" VALUES(46,'ChildTabControl','���������',1,46,NULL);
INSERT INTO "elements" VALUES(47,'Timer','������',2,1,NULL);
INSERT INTO "elements" VALUES(48,'Echo','����� ������',2,2,NULL);
INSERT INTO "elements" VALUES(49,'MessageBox','���� ���������',2,3,NULL);
INSERT INTO "elements" VALUES(50,'Prompt','���� ������',2,4,NULL);
INSERT INTO "elements" VALUES(51,'EventBehavior','�������� �������',2,5,NULL);
INSERT INTO "elements" VALUES(52,'StringsControl','�������� �����',2,6,NULL);
INSERT INTO "elements" VALUES(53,'StatusItem','��������� �������',2,7,NULL);
INSERT INTO "elements" VALUES(54,'FontEx','��������� ������',2,8,NULL);
INSERT INTO "elements" VALUES(55,'Brush','��������� �����',2,9,NULL);
INSERT INTO "elements" VALUES(56,'Pen','��������� ����',2,10,NULL);
INSERT INTO "elements" VALUES(57,'EditControl','��������� ���������',2,11,NULL);
INSERT INTO "elements" VALUES(58,'ReBarBand','��������� ReBar',2,12,NULL);
INSERT INTO "elements" VALUES(59,'HintControl','�������� ���������',2,13,NULL);
INSERT INTO "elements" VALUES(60,'ListViewColumns','��������� ������',2,14,NULL);
INSERT INTO "elements" VALUES(61,'ListItem','������� ������',2,15,NULL);
INSERT INTO "elements" VALUES(62,'HeaderItem','��������� ���������',2,16,NULL);
INSERT INTO "elements" VALUES(63,'PrintInfo','��������� ������',2,17,NULL);
INSERT INTO "elements" VALUES(64,'ActiveXControl','������� ����������',2,18,NULL);
INSERT INTO "elements" VALUES(65,'TreeItem','������� ������',2,19,NULL);
INSERT INTO "elements" VALUES(66,'HeaderControl','��������� ����������',2,20,NULL);
INSERT INTO "elements" VALUES(67,'Action','��������',2,21,NULL);
INSERT INTO "elements" VALUES(68,'Rectangle','�������������',3,1,NULL);
INSERT INTO "elements" VALUES(69,'Line','������',3,2,NULL);
INSERT INTO "elements" VALUES(70,'Ellipse','������',3,3,NULL);
INSERT INTO "elements" VALUES(71,'Arc','����',3,4,NULL);
INSERT INTO "elements" VALUES(72,'Bevel','�����',3,5,NULL);
INSERT INTO "elements" VALUES(73,'Chord','�����',3,6,NULL);
INSERT INTO "elements" VALUES(74,'Circle','����������',3,7,NULL);
INSERT INTO "elements" VALUES(75,'Pie','����',3,8,NULL);
INSERT INTO "elements" VALUES(76,'RoundRect','������������� ����������',3,9,NULL);
INSERT INTO "elements" VALUES(77,'Polygon','�������',3,10,NULL);
INSERT INTO "elements" VALUES(78,'TextOut','�����',3,11,NULL);
INSERT INTO "elements" VALUES(79,'LoadImage','�������� ��������',3,12,NULL);
INSERT INTO "elements" VALUES(80,'ImageList','������ �����������',3,13,NULL);
INSERT INTO "elements" VALUES(81,'WinEnum','������� ����',4,1,NULL);
INSERT INTO "elements" VALUES(82,'WinTools','�������� ��� ������',4,2,NULL);
INSERT INTO "elements" VALUES(83,'FindWindow','����� �����',4,3,NULL);
INSERT INTO "elements" VALUES(84,'SizeWindow','������ ����',4,4,NULL);
INSERT INTO "elements" VALUES(85,'PosWindow','��������� ����',4,5,NULL);
INSERT INTO "elements" VALUES(86,'MoveControl','����������� ��������',4,6,NULL);
INSERT INTO "elements" VALUES(87,'SendMessage','������� ���������',4,7,NULL);
INSERT INTO "elements" VALUES(88,'*Windows_Regions','�������',4,8,NULL);
INSERT INTO "elements" VALUES(89,'RectRgn','������������� ������',4,9,NULL);
INSERT INTO "elements" VALUES(90,'EllipticRgn','������������� ������',4,10,NULL);
INSERT INTO "elements" VALUES(91,'RoundRectRgn','������������� ������',4,11,NULL);
INSERT INTO "elements" VALUES(92,'PolygonRgn','������� ������',4,12,NULL);
INSERT INTO "elements" VALUES(93,'CombineRgn','����������� ��������',4,14,NULL);
INSERT INTO "elements" VALUES(94,'RgnFromImage','������ �� ��������',4,13,NULL);
INSERT INTO "elements" VALUES(95,'EqualRgn','��������� ��������',4,15,NULL);
INSERT INTO "elements" VALUES(96,'TransformRgn','��������� �������',4,16,NULL);
INSERT INTO "elements" VALUES(97,'Application','��������� ��������',5,1,NULL);
INSERT INTO "elements" VALUES(98,'WinExec','������ ����������',5,2,NULL);
INSERT INTO "elements" VALUES(99,'LogEvent','������ �������',5,3,NULL);
INSERT INTO "elements" VALUES(100,'GUID','���������� �������������',5,4,NULL);
INSERT INTO "elements" VALUES(101,'Zipper','Zip ���������',5,5,NULL);
INSERT INTO "elements" VALUES(102,'Font','��������� ������',5,6,NULL);
INSERT INTO "elements" VALUES(103,'Clipboard','����� ������ Windows',5,7,NULL);
INSERT INTO "elements" VALUES(104,'Registry','������/������ � ������',5,8,NULL);
INSERT INTO "elements" VALUES(105,'DrivesInfo','���������� � ������',5,9,NULL);
INSERT INTO "elements" VALUES(106,'ExitWindowsDialog','������ ������ �� �������',5,10,NULL);
INSERT INTO "elements" VALUES(107,'Time','������� �����',5,11,NULL);
INSERT INTO "elements" VALUES(108,'Ping','��������� � ����?',6,1,NULL);
INSERT INTO "elements" VALUES(109,'NsLookup','����� ����������',6,2,NULL);
INSERT INTO "elements" VALUES(110,'SendEmail','��������� ������',6,3,NULL);
INSERT INTO "elements" VALUES(111,'Socket','TCP ����������',6,4,NULL);
INSERT INTO "elements" VALUES(112,'SocketSend','����� ������',6,5,NULL);
INSERT INTO "elements" VALUES(113,'SocketGet','���� ������',6,6,NULL);
INSERT INTO "elements" VALUES(114,'HttpGet','�������� Web �������',6,7,NULL);
INSERT INTO "elements" VALUES(115,'WinHttp','������� � web-�������',6,8,NULL);
INSERT INTO "elements" VALUES(116,'odbc','ODBC connect',7,1,NULL);
INSERT INTO "elements" VALUES(117,'odbc_exec','������ � ���� ������',7,2,NULL);
INSERT INTO "elements" VALUES(118,'odbc_enumRS','������� ������',7,3,NULL);
INSERT INTO "elements" VALUES(119,'odbc_FieldReader','������ ������',7,4,NULL);
INSERT INTO "elements" VALUES(120,'*DataBase_������','������',7,5,NULL);
INSERT INTO "elements" VALUES(121,'ADODBStream','ADODB �o�o� ������',7,6,NULL);
INSERT INTO "elements" VALUES(122,'ADODBStreamRW','������ � ������� ADODB',7,7,NULL);
INSERT INTO "elements" VALUES(123,'ADODBStreamIO','����� ������ ������ � �����',7,8,NULL);
INSERT INTO "elements" VALUES(124,'ADODBStreamCopy','����������� ������',7,9,NULL);
INSERT INTO "elements" VALUES(125,'FileTools','�������� ��������',8,1,NULL);
INSERT INTO "elements" VALUES(126,'FilePart','���������� �����',8,2,NULL);
INSERT INTO "elements" VALUES(127,'FileSearch','����� ������',8,3,NULL);
INSERT INTO "elements" VALUES(128,'SpecFolder','����������� �����',8,4,NULL);
INSERT INTO "elements" VALUES(129,'DirTools','�������� � �������',8,5,NULL);
INSERT INTO "elements" VALUES(130,'Ini','������ � INI �������',8,6,NULL);
INSERT INTO "elements" VALUES(131,'ShortCut','����� �����',8,7,NULL);
INSERT INTO "elements" VALUES(132,'FileQuery','�o�c� �� �������� �������',8,8,NULL);
INSERT INTO "elements" VALUES(133,'*Files_�������','�������',8,9,NULL);
INSERT INTO "elements" VALUES(134,'Browse','�����',8,10,NULL);
INSERT INTO "elements" VALUES(135,'ODialog','�������� �����',8,11,NULL);
INSERT INTO "elements" VALUES(136,'SDialog','���������� �����',8,12,NULL);
INSERT INTO "elements" VALUES(137,'FileChooser','����� ������',8,13,NULL);
INSERT INTO "elements" VALUES(138,'*Files_������','������',8,14,NULL);
INSERT INTO "elements" VALUES(139,'FileTextStream','��������� �o�o�',8,15,NULL);
INSERT INTO "elements" VALUES(140,'FileTextStreamRW','������ � ������ ������',8,16,NULL);
INSERT INTO "elements" VALUES(141,'For','���� ��������',9,1,NULL);
INSERT INTO "elements" VALUES(142,'If_else','������� �� �������',9,2,NULL);
INSERT INTO "elements" VALUES(143,'Math','����������',9,3,NULL);
INSERT INTO "elements" VALUES(144,'MathParse','���. ���������',9,4,NULL);
INSERT INTO "elements" VALUES(145,'Case','������������ �� �������',9,5,NULL);
INSERT INTO "elements" VALUES(146,'Random','��������� �����',9,6,NULL);
INSERT INTO "elements" VALUES(147,'Rand','��������� �����',9,7,NULL);
INSERT INTO "elements" VALUES(148,'Rnd','��������� �����',9,8,NULL);
INSERT INTO "elements" VALUES(149,'While','���� � ��������',9,9,NULL);
INSERT INTO "elements" VALUES(150,'CaseEx','������������ �� �������',9,10,NULL);
INSERT INTO "elements" VALUES(151,'ForEach','���� ��������',9,11,NULL);
INSERT INTO "elements" VALUES(152,'Counter','�������� �������',9,12,NULL);
INSERT INTO "elements" VALUES(153,'Repeat','�������� ����',9,13,NULL);
INSERT INTO "elements" VALUES(154,'ArrayItem','������ � �������',10,1,NULL);
INSERT INTO "elements" VALUES(155,'ArrayEnum','������� �������',10,2,NULL);
INSERT INTO "elements" VALUES(156,'ArrayRead','������ �������',10,3,NULL);
INSERT INTO "elements" VALUES(157,'ArraySize','������ �������',10,4,NULL);
INSERT INTO "elements" VALUES(158,'ArrayWrite','������ � ������',10,5,NULL);
INSERT INTO "elements" VALUES(159,'StrArray','������ �����',10,6,NULL);
INSERT INTO "elements" VALUES(160,'ArrayRW','������ � ������ �������',10,7,NULL);
INSERT INTO "elements" VALUES(161,'IntArray','������ ����� �����',10,8,NULL);
INSERT INTO "elements" VALUES(162,'PointsArray','������ ��� ���������',10,9,NULL);
INSERT INTO "elements" VALUES(163,'Matrix','������� ������',10,10,NULL);
INSERT INTO "elements" VALUES(164,'MatrixRW','������ � ������ �������',10,11,NULL);
INSERT INTO "elements" VALUES(165,'Dictionary','�������',10,12,NULL);
INSERT INTO "elements" VALUES(166,'Hub','���',11,1,NULL);
INSERT INTO "elements" VALUES(167,'GetData','������ ��������� � ������',11,2,NULL);
INSERT INTO "elements" VALUES(168,'GetIndexData','������ �� �������',11,3,NULL);
INSERT INTO "elements" VALUES(169,'DoData','�����-������',11,4,NULL);
INSERT INTO "elements" VALUES(170,'EventFromData','������� ��������� � ������',11,5,NULL);
INSERT INTO "elements" VALUES(171,'Memory','������',11,6,NULL);
INSERT INTO "elements" VALUES(172,'ChanelToIndex','����� � ������',11,7,NULL);
INSERT INTO "elements" VALUES(173,'IndexToChanel','������ � �����',11,8,NULL);
INSERT INTO "elements" VALUES(174,'Switch','�������������',11,9,NULL);
INSERT INTO "elements" VALUES(175,'Stack','����������� �����',11,10,NULL);
INSERT INTO "elements" VALUES(176,'GlobalVar','���������� ����������',11,11,NULL);
INSERT INTO "elements" VALUES(177,'Var','����������',11,12,NULL);
INSERT INTO "elements" VALUES(178,'MultiElement','��������� �����',11,13,NULL);
INSERT INTO "elements" VALUES(179,'MultiElementEx','��������� �����',11,14,NULL);
INSERT INTO "elements" VALUES(180,'TimeCounter','������� �������',11,15,NULL);
INSERT INTO "elements" VALUES(181,'KeyMask','���������� ������',11,16,NULL);
INSERT INTO "elements" VALUES(182,'PointXY','����� �� �����������',11,17,NULL);
INSERT INTO "elements" VALUES(183,'Convertor','��������� �������',11,18,NULL);
INSERT INTO "elements" VALUES(184,'Informer','����������',11,19,NULL);
INSERT INTO "elements" VALUES(185,'ChangeMon','���������� ������',11,20,NULL);
INSERT INTO "elements" VALUES(186,'VisualInline','������� ����',12,1,NULL);
INSERT INTO "elements" VALUES(187,'InlineCode','������� ����',12,2,NULL);
INSERT INTO "elements" VALUES(188,'Sleep','�������� ���������',12,3,NULL);
INSERT INTO "elements" VALUES(189,'Eval','���������� ������ ����',12,4,NULL);
INSERT INTO "elements" VALUES(190,'Header','',12,5,NULL);
INSERT INTO "elements" VALUES(191,'NoErr','���������� ������',12,6,NULL);
INSERT INTO "elements" VALUES(192,'ErrHandler','',12,7,NULL);
INSERT INTO "elements" VALUES(193,'ExecGlobal','���������� ����',12,8,NULL);
INSERT INTO "elements" VALUES(194,'Function','�������� �������',12,9,NULL);
INSERT INTO "elements" VALUES(195,'CallFunc','����� �������',12,10,NULL);
INSERT INTO "elements" VALUES(196,'WScript','������ WScript',12,11,NULL);
INSERT INTO "elements" VALUES(197,'FieldRead','������ ���� �������',12,12,NULL);
INSERT INTO "elements" VALUES(198,'FieldWrite','������ ���� �������',12,13,NULL);
INSERT INTO "elements" VALUES(199,'StrCat','����������� �����',13,1,NULL);
INSERT INTO "elements" VALUES(200,'Length','����� ������',13,2,NULL);
INSERT INTO "elements" VALUES(201,'Position','������� � ������',13,3,NULL);
INSERT INTO "elements" VALUES(202,'Copy','����� ������',13,4,NULL);
INSERT INTO "elements" VALUES(203,'FormatStr','��������������� ������',13,5,NULL);
INSERT INTO "elements" VALUES(204,'Replace','������',13,6,NULL);
INSERT INTO "elements" VALUES(205,'ArraySplit','�������� ������',13,7,NULL);
INSERT INTO "elements" VALUES(206,'StrList','������ �����',13,8,NULL);
INSERT INTO "elements" VALUES(207,'Trim','�������� ��������',13,9,NULL);
INSERT INTO "elements" VALUES(208,'StrCase','�������',13,10,NULL);
INSERT INTO "elements" VALUES(209,'Symbol','�����������',13,11,NULL);
INSERT INTO "elements" VALUES(210,'MultiStrData','��������� ������',13,12,NULL);
INSERT INTO "elements" VALUES(211,'RegExp','���������� ���������',13,13,NULL);
INSERT INTO "elements" VALUES(212,'Hashsum','��� ����� MD5',13,14,NULL);
INSERT INTO "elements" VALUES(213,'HexDump','����������������� ����',13,15,NULL);
INSERT INTO "elements" VALUES(214,'TextConvertor','������������� ������',13,16,NULL);
INSERT INTO "elements" VALUES(215,'Const','����������� ���������',14,1,NULL);
INSERT INTO "elements" VALUES(216,'Color','�������� ���������',14,2,NULL);
INSERT INTO "elements" VALUES(217,'WeekDay','��������� ��� ������',14,3,NULL);
INSERT INTO "elements" VALUES(218,'Tristate','������� ���������',14,4,NULL);
INSERT INTO "elements" VALUES(219,'*Helpers_�����','�����',15,1,NULL);
INSERT INTO "elements" VALUES(220,'Debug','�������',15,2,NULL);
INSERT INTO "elements" VALUES(221,'LineBreak','������ �����',15,3,NULL);
INSERT INTO "elements" VALUES(222,'LineBreakEx','������ �����',15,4,NULL);
INSERT INTO "elements" VALUES(223,'HubEx','����',15,5,NULL);
INSERT INTO "elements" VALUES(224,'GetDataEx','����',15,6,NULL);
INSERT INTO "elements" VALUES(225,'Check','������',15,7,NULL);
INSERT INTO "elements" VALUES(226,'*Helpers_������','������',15,8,NULL);
INSERT INTO "elements" VALUES(227,'InfoTip','�������',15,9,NULL);
INSERT INTO "elements" VALUES(228,'LinkTip','������',15,10,NULL);
INSERT INTO "elements" VALUES(229,'Shape','������',15,11,NULL);
INSERT INTO "elements" VALUES(230,'PictureTip','�������� � ���������',15,12,NULL);
INSERT INTO "elements" VALUES(231,'PointHint','������',15,13,NULL);
INSERT INTO "elements" VALUES(232,'ImageMulti','����� � ���������',15,14,NULL);
INSERT INTO "elements" VALUES(233,'ViewSHA','����� � ���������',15,15,NULL);
INSERT INTO "elements" VALUES(234,'*Helpers_�����','�����',15,16,NULL);
INSERT INTO "elements" VALUES(235,'SDKBtn','������ �� ������� �����',15,17,NULL);
INSERT INTO "elements" VALUES(236,'AccessFTP','������ � FTP',15,18,NULL);
INSERT INTO "elements" VALUES(237,'ScriptEvents','������� �������',15,19,NULL);
INSERT INTO "elements" VALUES(238,'BugReport','���� ������ � �����',15,20,NULL);
INSERT INTO "elements" VALUES(239,'MainForm','�����',16,1,NULL);
INSERT INTO "elements" VALUES(240,'EntryPoint','����� �����',16,2,NULL);
INSERT INTO "elements" VALUES(241,'WinControl','������� ����������',16,3,NULL);
INSERT INTO "elements" VALUES(242,'Form','�����',16,4,NULL);
INSERT INTO "elements" VALUES(243,'Panel','������',16,5,NULL);
INSERT INTO "elements" VALUES(244,'GroupBox','������ ���������',16,6,NULL);
INSERT INTO "elements" VALUES(245,'EditMultiEx','�������� ���������� Ex',16,7,NULL);
INSERT INTO "elements" VALUES(246,'EditMulti','�������� ����������',16,8,NULL);
INSERT INTO "elements" VALUES(247,'PointElement','�����',16,9,NULL);
INSERT INTO "elements" VALUES(248,'ReBar','���������',16,10,NULL);
INSERT INTO "elements" VALUES(249,'Pager','���������',16,11,NULL);
INSERT INTO "elements" VALUES(250,'TabControl','��������',16,12,NULL);
INSERT INTO "elements" VALUES(251,'Tab','��������',16,13,NULL);
INSERT INTO "elements" VALUES(252,'Img_Rectangle','�������������',16,14,NULL);
INSERT INTO "elements" VALUES(253,'Img_Line','�����',16,15,NULL);
INSERT INTO "elements" VALUES(254,'Img_Ellipse','������',16,16,NULL);
INSERT INTO "elements" VALUES(255,'Img_Polygon','�������������',16,17,NULL);
INSERT INTO "elements" VALUES(256,'Img_Text','��������� ������',16,18,NULL);
INSERT INTO "elements" VALUES(257,'ChildForm','�������� ���������� �����',16,19,NULL);
INSERT INTO "elements" VALUES(258,'DialogForm','�������� ���������� �����',16,20,NULL);
INSERT INTO "elements" VALUES(259,'Message','Message Box',16,21,NULL);
INSERT INTO "elements" VALUES(260,'CustomCode','���������������� �������',17,1,NULL);
INSERT INTO "elements" VALUES(261,'CG_LevelControl','�������� ������',17,2,NULL);
INSERT INTO "elements" VALUES(262,'CG_Trace','�������',17,3,NULL);
INSERT INTO "elements" VALUES(263,'CG_HiAsmVersion','������ HiAsm',17,4,NULL);
INSERT INTO "elements" VALUES(264,'CG_BuildTime','����� ������',17,5,NULL);
INSERT INTO "elements" VALUES(265,'CG_IDController','���������� ID',17,6,NULL);
INSERT INTO "elements" VALUES(266,'*CodeGen_�����','�����',17,7,NULL);
INSERT INTO "elements" VALUES(267,'CG_BlockPrint','����� �����',17,8,NULL);
INSERT INTO "elements" VALUES(268,'CG_BlockReg','����������� �����',17,9,NULL);
INSERT INTO "elements" VALUES(269,'CG_BlockSelect','����� �����',17,10,NULL);
INSERT INTO "elements" VALUES(270,'CG_BlockDelete','�������� �����',17,11,NULL);
INSERT INTO "elements" VALUES(271,'CG_BlockIncLevel','���������� �������',17,12,NULL);
INSERT INTO "elements" VALUES(272,'CG_BlockDecLevel','���������� �������',17,13,NULL);
INSERT INTO "elements" VALUES(273,'Beep','��� �� ��������',18,1,NULL);
INSERT INTO "elements" VALUES(274,'RegistryWMI','��������� ������',19,1,NULL);
INSERT INTO "elements" VALUES(275,'RegistryEventsWMI','������� �������',19,2,NULL);
INSERT INTO "elements" VALUES(276,'ProcessCheckWMI','������ ��������',19,3,NULL);
INSERT INTO "elements" VALUES(277,'ProcessEventsWMI','������� ��������',19,4,NULL);
INSERT INTO "elements" VALUES(278,'ProcessEnumWMI','������� ���������',19,5,NULL);
INSERT INTO "elements" VALUES(279,'ProcessControlWMI','���������� ���������',19,6,NULL);
INSERT INTO "elements" VALUES(280,'ScheduledJobWMI','�������� �������',19,7,NULL);
INSERT INTO "elements" VALUES(281,'PingStatusWMI','Ping ����������',19,8,NULL);
INSERT INTO "elements" VALUES(282,'CPUusageWMI','�������� �� ���',19,9,NULL);
INSERT INTO "elements" VALUES(283,'ConnectWMI','���������� � WMI',19,10,NULL);
INSERT INTO "elements" VALUES(284,'ExitWindowsWMI','����� �� �������',19,11,NULL);
INSERT INTO "elements" VALUES(285,'MT_Add','���������� ��������',20,1,NULL);
INSERT INTO "elements" VALUES(286,'MT_Get','������ ������ �� ������������ ������',20,2,NULL);
INSERT INTO "elements" VALUES(287,'MT_IndexToChannel','�������� ������� �� ������� � ������',20,3,NULL);
INSERT INTO "elements" VALUES(288,'MT_ChannelToIndex','���������� ������ �������������� ����� �����',20,4,NULL);
INSERT INTO "elements" VALUES(289,'MT_MTtoDataChannel','������� �� ������ � ���������������� ������ ������',20,5,NULL);
INSERT INTO "elements" VALUES(290,'MT_Enum','������� ������ ������������ ������',20,6,NULL);
INSERT INTO "elements" VALUES(291,'Printf','������ �� �������',13,17,NULL);
INSERT INTO "elements" VALUES(292,'Inline','������� ��������� ���������',12,14,NULL);
CREATE TABLE files(id INTEGER PRIMARY KEY AUTOINCREMENT,name varchar(128),count int);
CREATE TABLE files_link(file_id int,el_id int);
COMMIT;
