#include "share.h"

class THIHTTP_PostBuilder:public TDebug
{
   private:
   public:
    string _prop_Content;
    string _prop_URL;
    string _prop_Host;
    string _prop_Referer;
    string _prop_UserAgent;

    THI_Event *_data_Content;
    THI_Event *_data_URL;
    THI_Event *_data_Host;
    THI_Event *_data_Referer;
    THI_Event *_data_Session;
    THI_Event *_data_Cookies;
    THI_Event *_data_UserAgent;
    THI_Event *_event_onBuild;

    HI_WORK_LOC(THIHTTP_PostBuilder,_work_doBuild);
};

///////////////////////////////////////////////////////////////

void THIHTTP_PostBuilder::_work_doBuild(TData &_Data,WORD Index)
{
    string c = ReadString(_Data, _data_Content, _prop_Content);
    string u = ReadString(_Data, _data_URL, _prop_URL);
    string h = ReadString(_Data, _data_Host, _prop_Host);
    string r = ReadString(_Data, _data_Referer, _prop_Referer);
    string ss = ReadString(_Data, _data_Session, SNULL);
    string cc = ReadString(_Data, _data_Cookies, SNULL);
    string su = ReadString(_Data, _data_UserAgent, _prop_UserAgent);
    
   string s = string(_his("POST ")) + u + _his(" HTTP/1.1\r\n") +
              _his("Host: ") + h + _his("\r\n") +
              _his("Connection: close\r\n") + 
              _his("Content-Type: application/x-www-form-urlencoded\r\n");
   if(!r.Empty())
     s += string(_his("Referer: ")) + r + _his("\r\n");
   
   if(!ss.Empty() || !cc.Empty())
   {
     s += string(_his("Cookie: "));
     
     if(!ss.Empty())
     {
       s += string(_his("PHPSESSID=")) + ss;
       if(!cc.Empty()) s += string(_his(";"));
     }
     s += cc + _his("\r\n"); 
   }
     
   if(!su.Empty())
     s += string(_his("User-Agent: ")) + su + _his("\r\n");

   s += string(_his("Content-Length: ")) + IntToStr(c.Length()) + _his("\r\n\r\n") + c + _his("\r\n");

    _hi_onEvent(_event_onBuild,s);
}
