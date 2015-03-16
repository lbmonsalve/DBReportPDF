#tag Module
Protected Module DBReportShared
	#tag Method, Flags = &h1
		Protected Function zlibCompress(input as String) As String
		  zlibLastErrorCode= 0
		  
		  Soft Declare Function zlibcompress Lib kzlibPath Alias "compress" (dest As Ptr, ByRef destLen As Uint32, source As CString, sourceLen As UInt32) As Integer
		  
		  Dim output As New MemoryBlock(12+ 1.002* LenB(input))
		  Dim outputSize As UInt32= output.Size
		  
		  zlibLastErrorCode= zlibcompress(output, outputSize, input, LenB(input))
		  If zlibLastErrorCode= 0 Then
		    Return output.StringValue(0, outputSize)
		  Else
		    Return ""
		  End
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function zlibUncompress(input as String, bufferSize as Integer = 0) As String
		  zlibLastErrorCode= 0
		  
		  If bufferSize= 0 Then
		    bufferSize= 4* LenB(input)
		  End
		  
		  Do
		    Soft Declare Function zlibuncompress Lib kzlibPath Alias "uncompress" (dest As Ptr, ByRef destLen As UInt32, source As CString, sourceLen As Uint32) As Integer
		    
		    Dim m As New MemoryBlock(bufferSize)
		    Dim destLength As UInt32= m.Size
		    zlibLastErrorCode= zlibuncompress(m, destLength, input, LenB(input))
		    If zlibLastErrorCode= 0 Then
		      Return m.StringValue(0, destLength)
		    ElseIf zlibLastErrorCode= Z_BUF_ERROR Then
		      bufferSize= bufferSize+ bufferSize
		    Else
		      Return ""
		    End if
		  Loop
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function zlibVersion() As String
		  Soft Declare Function zlibVersion Lib kzlibPath () As Ptr
		  
		  Dim mb As MemoryBlock= zlibVersion
		  If mb<> Nil Then
		    Return mb.CString(0)
		  Else
		    Return ""
		  End if
		End Function
	#tag EndMethod


	#tag Note, Name = Readme
		
		DBReportPDF v0.1.1201
		
		Fork of https://github.com/roblthegreat/rsfpdf
		
		TODO:
		
		DPI
		Embedded fonts
	#tag EndNote

	#tag Note, Name = zlibDocumentation
		zlib
		3/22/2007
		charles@declareSub.com
		http://www.declareSub.com
		
		
		zlib is a wrapper for the zlib compression library, available on Mac OS X, Linux, and Windows.
		It currently consists of a module, zlib, and a class, gzipStream.  Documentation for gzipStream
		can be found in the class.
		
		zlib is compatible with gzipped files, but not zipped files.
		--------------------------------------------------------
		
		Module zlib
		
		zlibCompress and zlibUncompress provide in-memory compression of
		REALbasic strings.
		
		Using zlibCompress is simple.
		
		dim output as String = zlibCompress(input)
		
		Using zlibUncompress is slightly more complicated.  The length of the uncompressed
		string is not stored in the compressed string.  zlibUncompress uses a simple strategy to
		guess the amount of buffer space needed to uncompress the input.  If you happen to know the
		size of the uncompressed data in bytes, you can pass it to zlibUncompress in the optional second 
		parameter to possibly speed things up a bit.
		
		dim output as String = zlibUncompress(input)
		dim output as String = zlibUncompress(input, 740526)
		
		The Version function returns the version of zlib.
		
		LastErrorCode contains the last error code returned by a zlib function.
		
		Error codes for zlibCompress:  Z_OK = no error, Z_MEM_ERROR = not enough memory, Z_BUF_ERROR = buffer too small.
		
		Error codes fror zlibUncompress: Z_OK = no error, Z_MEM_ERROR = not enough memory, Z_DATA_ERROR = corrupted data.
	#tag EndNote


	#tag Property, Flags = &h1
		Protected zlibLastErrorCode As Integer
	#tag EndProperty


	#tag Constant, Name = kzlibPath, Type = String, Dynamic = False, Default = \"", Scope = Protected
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"/usr/lib/libz.dylib"
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"ZLIB1.DLL"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"/usr/lib/libz.so.1"
	#tag EndConstant

	#tag Constant, Name = Z_BUF_ERROR, Type = Double, Dynamic = False, Default = \"-5", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_DATA_ERROR, Type = Double, Dynamic = False, Default = \"-3", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_ERRNO, Type = Double, Dynamic = False, Default = \"-1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_MEM_ERROR, Type = Double, Dynamic = False, Default = \"-4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_OK, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_STREAM_ERROR, Type = Double, Dynamic = False, Default = \"-2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Z_VERSION_ERROR, Type = Double, Dynamic = False, Default = \"-6", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
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
	#tag EndViewBehavior
End Module
#tag EndModule
