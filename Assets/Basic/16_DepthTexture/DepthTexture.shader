Shader "MineselfShader/Basic/16-DepthTexture/DepthTexture"
{
    Properties
    {
        
    }
    SubShader
    {
        //SubShader Tags
		Tags{"Queue"="Geometry+1"}
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            sampler2D _CameraDepthTexture;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 screenPos : TEXCOORD0;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.screenPos = ComputeScreenPos(o.pos);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float depth01 = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)).r;

                return depth01;
            }
            ENDCG
        }
    }
    Fallback Off
}