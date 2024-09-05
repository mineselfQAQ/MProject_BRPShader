Shader "MineselfShader/Advance/1-ToonWater/NormalVisualization"
{
    Properties
    {
        
    }
    SubShader
    {
        //SubShader Tags
		Tags{"RenderType"="Opaque"}
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
            
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 vNormal : TEXCOORD0;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.vNormal = COMPUTE_VIEW_NORMAL;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                return float4(i.vNormal, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}