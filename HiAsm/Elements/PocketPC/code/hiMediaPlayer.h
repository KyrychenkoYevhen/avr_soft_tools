#include "Share.h"
#include "MCIMedia.h"

class THIMediaPlayer
{
   private:
    TMedia *FMedia;

    //procedure onEndPlay( Sender: PKOLMediaPlayer; NotifyValue: TMPNotifyValue );
    //function _OnMes( var Msg: TMsg; var Rslt: Integer ): Boolean;

    //procedure _OnEnd(Sender:PObj);
    //procedure SetVideoScale(Value:byte);
   public:
    HI_STRING _prop_Filename;
    THI_Event *_data_FileName;
    THI_Event *_data_Handle;
    THI_Event *_event_onEndPlay;

    THIMediaPlayer(){ FMedia = new TMedia(ReadHandle); }
    ~THIMediaPlayer(){ delete FMedia; }

    HI_WORK_LOC(_work_doPlay);
    HI_WORK_LOC(_work_doStop);
    HI_WORK_LOC(_work_doPause);
    HI_WORK_LOC(_work_doPosition);
    HI_WORK_LOC(_var_Position);
    HI_WORK_LOC(_var_Length);

    //property _prop_VideoScale:byte write SetVideoScale;
};

//#############################################################################

/*
procedure THIMediaPlayer._OnEnd;
begin
   if FMedia.Position = FMedia.Length then
    begin
      th.Enabled := false;
      _hi_OnEvent(_event_onEndPlay);        
    end;
end;
*/

void THIMediaPlayer::_work_doPlay(TData &_Data,USHORT Index)
{
   HI_STRING FName = ReadString(_Data,_data_FileName,_prop_FileName);
   //WndH = ReadInteger(_Data,_data_Handle,0);

   if( FileExists(FName) )
   {
     FMedia->Close();
     FMedia->Open(FName);
     FMedia->Play();
   }
}

void THIMediaPlayer::_work_doStop(TData &_Data,USHORT Index)
{
   FMedia->Stop();
   //FMedia->Position := 0;
}

void THIMediaPlayer::_work_doPause(TData &_Data,USHORT Index)
{
   //FMedia.Pause := not FMedia.Pause;
   //th.Enabled := not FMedia.Pause;
   FMedia->Pause();
}

void THIMediaPlayer::_work_doPosition(TData &_Data,USHORT Index)
{
   if( FMedia->GetLength() )
   {
      FMedia->SetPosition( ToInteger(_Data) );
      //FMedia.Play(WndH,0,FMedia.Length);
   }
}

void THIMediaPlayer::_var_Position(TData &_Data,USHORT Index)
{
    CreateData(_Data,FMedia->GetPosition());
}

void THIMediaPlayer::_var_Length(TData &_Data,USHORT Index)
{
    CreateData(_Data,FMedia->GetLength());
}
