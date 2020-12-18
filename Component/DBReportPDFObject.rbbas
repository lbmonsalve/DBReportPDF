#tag Class
Protected Class DBReportPDFObject
	#tag Method, Flags = &h0
		Sub Constructor()
		  'Constants:
		  CR= EndOfLine.Macintosh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DataStream() As string
		  Return Str(Number)+" "+Str(Generator)+" obj "+GetData+"endobj"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function FormatDate(Optional d As Date) As String
		  Dim dTmp As Date
		  If d= Nil Then dTmp= New Date Else dTmp= d
		  
		  Return "D:"+ ReplaceAll(ReplaceAll(ReplaceAll(str(dTmp.SQLDateTime),"-",""),":","")," ","")+ _
		  ReplaceAll(ReplaceAll(Format(dTmp.GMTOffset, "+00.00"), ",", "'"), ".", "'")+ "'"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function FormatEscapeChars(src As String) As String
		  src= ReplaceLineEndings(src, EndOfLine.Windows)
		  src= src.ReplaceAll("\", "\\")
		  src= src.ReplaceAll("(", "\(")
		  src= src.ReplaceAll(")", "\)")
		  src= src.ReplaceAll(Chr(9), "\t")
		  src= src.ReplaceAll(CR, "\n")
		  
		  Dim s, char As String
		  Dim c As Integer
		  For i As Integer= 1 To src.Len
		    char= src.Mid(i, 1)
		    If char= "€" Then // special case
		      s= s+ "\200"
		    Else
		      c= ConvertEncoding(char, Encodings.ISOLatin1).Asc
		      If c>= 32 And c<= 126 Then
		        s= s+ Encodings.ASCII.Chr(c)
		      Else
		        s= s+ "\"+ Oct(c)
		      End
		    End If
		  Next
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function FormatHexString(src As String) As String
		  Return "<"+ EncodeHex(src)+ ">"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Shared Function FormatLiteralString(src As String) As String
		  Return "("+ FormatEscapeChars(src)+ ")"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Shared Function Fs(whichNum As Double) As String
		  Dim s As String= ReplaceAll(Format(whichNum, "-0.#####"), ",", ".")
		  
		  If Right(s, 1)= "." Then
		    Return Left(s, len(s)- 1)
		  End
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetData() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IndirectReference() As String
		  Return Str(Number)+" "+ Str(Generator)+" R"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		ByteOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Shared CR As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Generator As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Number As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Type As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ByteOffset"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Generator"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Number"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
