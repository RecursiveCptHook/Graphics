﻿using UnityEngine;
using UnityEditor.Graphing;

namespace UnityEditor.ShaderGraph
{
	[Title("Utility", "Logic", "Is Front Face")]
	class IsFrontFaceNode : AbstractMaterialNode, IGeneratesBodyCode, IMayRequireFaceSign
	{
		public IsFrontFaceNode()
		{
			name = "Is Front Face";
			UpdateNodeAfterDeserialization();
		}

		public override string documentationURL
		{
			get { return "https://github.com/Unity-Technologies/ShaderGraph/wiki/Is-Front-Face-Node"; }
		}

		public override bool hasPreview { get { return false; } }

		public const int OutputSlotId = 0;
        private const string kOutputSlotName = "Out";

		public override void UpdateNodeAfterDeserialization()
        {
            AddSlot(new BooleanMaterialSlot(OutputSlotId, kOutputSlotName, kOutputSlotName, SlotType.Output, true, ShaderStageCapability.Fragment));
            RemoveSlotsNameNotMatching(new[] { OutputSlotId });
        }

        public void GenerateNodeCode(ShaderSnippetRegistry registry, GraphContext graphContext, GenerationMode generationMode)
        {
			using(registry.ProvideSnippet(GetVariableNameForNode(), guid, out var s))
            {
                s.AppendLine("{0} {1} = max(0, IN.{2});", precision, GetVariableNameForSlot(OutputSlotId), ShaderGeneratorNames.FaceSign);
            }
        }

		public bool RequiresFaceSign(ShaderStageCapability stageCapability = ShaderStageCapability.Fragment)
		{
			return true;
		}
	}
}
