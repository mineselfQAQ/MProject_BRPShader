Shader "MineselfShader/Test/ClipMode_Test1"
{
    Properties
    {
        _Cutout("Cutout", Range(-1, 1)) = -1
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="AlphaTest" 
            "RenderType"="TransparentCutout" 
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            float _Cutout;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 oPos : TEXCOORD0;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.oPos = v.vertex;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float mask = i.oPos.y;

                clip(mask - _Cutout);

                return float4(mask.rrr, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}