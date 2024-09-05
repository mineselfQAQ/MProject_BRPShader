Shader "MineselfShader/VFX/8-Billboard/Billboard_ObjectSpace"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [HDR]_Color("Color", COLOR) = (1,1,1,1)
        [KeywordEnum(Spherical, Cylindrical)]_Type("Type", Float) = 0
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
            "DisableBatching"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��
            #pragma shader_feature _TYPE_SPHERICAL _TYPE_CYLINDRICAL
			
            //��������
            sampler2D _MainTex;
            fixed4 _Color;

                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;

                //����ǰ����
                float3 forwardDir = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)).xyz;
                //�����������---ֻ�������ң�����������
                #if _TYPE_CYLINDRICAL
                    forwardDir.y = 0;
                #endif
                	forwardDir = normalize(forwardDir);

                //������ʱ������--->������--->������
                float3 upDir = abs(forwardDir.y) > 0.999 ? float3(0,0,1) : float3(0,1,0);
                float3 rightDir = normalize(cross(forwardDir, upDir));
                upDir = normalize(cross(rightDir, forwardDir));

                //����ռ��Billboard�ĺ���---�任����λ��ʹ������ӽ�
                float3x3 rotationMat = float3x3(rightDir, upDir, -forwardDir);
                float3 vertex = mul(transpose(rotationMat), v.vertex);

                o.pos = UnityObjectToClipPos(vertex);

                o.uv = v.uv;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                mainTex.rgb *= _Color;

                clip(mainTex.a - 0.5);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}