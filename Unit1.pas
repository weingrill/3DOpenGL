unit Unit1;

interface

uses
  Windows, Forms, OpenGL, Classes, ExtCtrls, Messages;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    RC    : HGLRC;
    Angle : Integer;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  end;

var
  MainForm: TMainForm;

implementation

uses Dialogs;

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin // initialize OpenGL and create a context for rendering
  RC:=CreateRenderingContext(Canvas.Handle,[opDoubleBuffered],32,0);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin // destroy the rendering context
  DestroyRenderingContext(RC);
end;

procedure cube;
begin
  glVertex3f(0,0,0);
  glVertex3f(0,0,1);
  glVertex3f(0,1,1);
  glVertex3f(0,1,0);
  glVertex3f(0,0,0);
  glVertex3f(1,0,0);
  glVertex3f(1,0,1);
  glVertex3f(1,1,1);
  glVertex3f(1,1,0);
  glVertex3f(1,0,0);
  glVertex3f(0,0,0);
  glVertex3f(0,1,1);
  glVertex3f(1,1,1);
  glVertex3f(1,0,0);
  glVertex3f(0,0,0);
  glVertex3f(0,1,0);
  glVertex3f(0,0,1);
  glVertex3f(1,0,1);
  glVertex3f(1,1,0);
  glVertex3f(0,1,0);
end;

procedure tetra;
begin
  glVertex3f(0,0,0); //Basis
  glVertex3f(0,0,1);
  glVertex3f(0,1,0);
  glVertex3f(0,0,0);
  glVertex3f(1,0,0);
  glVertex3f(0,1,0);
  glVertex3f(0,0,0);
  glVertex3f(1,0,0);
  glVertex3f(0,0,1);
  glVertex3f(0,0,0);
  glVertex3f(1,0,0);
  glVertex3f(0,0,1);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin // draw somthing useful
  ActivateRenderingContext(Canvas.Handle,RC); // make context drawable
  glClearColor(0,0,0,1); // background color of the context
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT); // clear background and depth buffer
  glMatrixMode(GL_MODELVIEW); // activate the transformation matrix
  glLoadIdentity;             // set it to initial state
  glEnable(GL_DEPTH_TEST); // enable depth testing
  gluLookAt(0,0,6,0,0,-10,0,1,0); // set up a viewer position and view point
  glTranslatef(0,0,0);
  glRotatef(30,1,0,0);
  glRotatef(Angle,0,1,0);
  glBegin(GL_LINE_STRIP);
    glColor3f(0,1,1);
    tetra;
  glEnd;
  glRotatef(5,0,1,0);
  glBegin(GL_LINE_STRIP);
    glColor3f(1,0,1);
    tetra;
  glEnd;
  SwapBuffers(Canvas.Handle); // copy back buffer to front
  DeactivateRenderingContext; // release control of context
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Application.Terminate;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin // handle form resizing (viewport must be adjusted)
  wglMakeCurrent(Canvas.handle,RC); // another way to make context drawable
  glViewport(0,0,Width,Height); // specify a viewport (has not necessarily to be the entire window)
  glMatrixMode(GL_PROJECTION); // activate projection matrix
  glLoadIdentity;              // set initial state
  gluPerspective(35,Width/Height,1,100); // specify perspective params (see OpenGL.hlp)
  wglMakeCurrent(0,0); // another way to release control of context
  Refresh;             // cause redraw
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin // do some animation
  Inc(Angle,1);
  if Angle >= 360 then Angle:=0;
  Repaint;
end;

procedure TMainForm.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin // avoid clearing the background (causes flickering and speed penalty)
  Message.Result:=1;
end;

end.

