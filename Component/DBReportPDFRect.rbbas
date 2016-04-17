#tag Class
Protected Class DBReportPDFRect
	#tag Method, Flags = &h0
		Sub Constructor(x As Double, y As Double, width As Double, height As Double)
		  mX= x
		  mY= y
		  mWidth= width
		  mHeight= height
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DataStream() As String
		  Return "["+ str(mX)+ " "+ str(mY)+ " "+ str(mWidth)+ " "+ str(mHeight)+ "]"
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Round(mHeight)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHeight= value
			End Set
		#tag EndSetter
		Height As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Round(mX)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mX= value
			End Set
		#tag EndSetter
		Left As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mHeight As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWidth As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mX As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mY As Double
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Round(mY)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mY= value
			End Set
		#tag EndSetter
		Top As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Round(mWidth)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mWidth= value
			End Set
		#tag EndSetter
		Width As Integer
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Height"
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
			Name="Width"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
