#tag Window
Begin Window Window1
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   400
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   1551912959
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "DBReportPDF Example"
   Visible         =   True
   Width           =   600
   Begin BevelButton BevelButton1
      AcceptFocus     =   False
      AutoDeactivate  =   True
      BackColor       =   0
      Bevel           =   0
      Bold            =   False
      ButtonType      =   0
      Caption         =   "PDF"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      Enabled         =   True
      HasBackColor    =   False
      HasMenu         =   0
      Height          =   22
      HelpTag         =   ""
      Icon            =   ""
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      MenuValue       =   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   ""
      TextUnit        =   0
      Top             =   14
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   60
   End
   Begin ComboBox ComboBox1
      AutoComplete    =   False
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   ""
      Left            =   146
      ListIndex       =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   16
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   339
   End
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   92
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      Text            =   "Font:"
      TextAlign       =   2
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   16
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   42
   End
End
#tag EndWindow

#tag WindowCode
#tag EndWindowCode

#tag Events BevelButton1
	#tag Event
		Sub Action()
		  Dim pdf As New DBReportPDF //Default page size: letter
		  pdf.Author= "Bernardo Monsalve"
		  pdf.Title= "DBReportPDF test"
		  pdf.Subject= "Test 01"
		  pdf.Keywords= "dbreport, dbreportpdf (class) \ real xojo"+ EndOfLine+ "+ hello"
		  
		  pdf.TextFont= "Times"
		  pdf.DrawString "He llo wo rld Hell o wor ld", 100, 100, 50
		  pdf.DrawLine 20, 20, 40, 40
		  
		  pdf.ForeColor= &cFF000000
		  pdf.TextFont= ComboBox1.Text
		  pdf.TextSize= 20
		  pdf.DrawString "Test Font: "+ ComboBox1.Text+ " áéíóú ñ ü", 100, 300
		  pdf.Bold= True
		  pdf.DrawString "Title", 50, 50
		  pdf.ForeColor= &c40004000
		  pdf.Italic= True
		  pdf.DrawString "Subtitle", 50, 50+ pdf.TextHeight
		  pdf.PenWidth= 2
		  pdf.DrawRect 20, 20, 20, 20
		  
		  pdf.PenWidth= 1
		  pdf.DrawRoundRect 200, 20, 20, 20, 10, 10
		  
		  pdf.ForeColor= &cFF800000
		  pdf.FillRect 230, 20, 20, 20
		  
		  pdf.ForeColor= &c00804000
		  pdf.FillRoundRect 260, 20, 20, 20, 5, 5
		  
		  pdf.DrawPicture SaveFile, 300, 40
		  pdf.DrawPicture Beer, 300, 100
		  
		  pdf.NextPage
		  pdf.Landscape= True
		  
		  pdf.DrawPicture Beer, 300, 100, 100, 120
		  
		  pdf.DrawOval 200, 20, 20, 20
		  
		  Dim p1() As Double= Array(20.0, 20.0, 20.0, 30.0, 30.0, 30.0, 10.0, 40.0)
		  pdf.DrawPolygon p1
		  
		  pdf.FillOval 100, 100, 200, 200
		  
		  Dim p2() As Double= Array(400.0, 50.0, 450.0, 60.0, 440.0, 55.0, 400.0, 40.0)
		  pdf.FillPolygon p2
		  
		  Dim f as FolderItem
		  
		  #if TargetLinux
		    f= SpecialFolder.UserHome.Child("DBReportPDF test.pdf")
		  #else
		    f= SpecialFolder.Documents.Child("DBReportPDF test.pdf")
		  #endif
		  
		  pdf.Save(f)
		  
		  f.Launch
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ComboBox1
	#tag Event
		Sub Open()
		  Dim s() As String
		  
		  For i As Integer= 1 To FontCount- 1
		    s.Append Font(i)
		  Next
		  s.Sort
		  
		  Me.AddRows s
		  
		  Me.ListIndex= 0
		End Sub
	#tag EndEvent
#tag EndEvents
