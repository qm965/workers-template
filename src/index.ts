import { Worker } from "@notionhq/workers";
import { j } from "@notionhq/workers/schema-builder";
import { NotionToMarkdown } from "notion-to-md";

const worker = new Worker();
export default worker;

worker.tool("extractFullDocument", {
	title: "Extract Full Document",
	description:
		"完整提取一个 Notion 页面的所有文本内容（包含所有嵌套块），以 Markdown 格式返回。适合读取长文档、书籍或超出 AI 上下文窗口限制的文章。",
	schema: j.object({
		pageId: j
			.string()
			.describe(
				"要提取内容的 Notion 页面 ID（32位字符串，或页面 URL 末尾的 ID 部分）",
			),
		followChildPages: j
			.boolean()
			.describe("是否递归进入子页面提取内容，默认为 false")
			.nullable(),
	}),
	outputSchema: j.object({
		content: j.string(),
		truncated: j.boolean(),
		charCount: j.number(),
	}),
	execute: async ({ pageId, followChildPages }, { notion }) => {
		const n2m = new NotionToMarkdown({
			notionClient: notion,
			config: {
				parseChildPages: followChildPages ?? false,
			},
		});

		const mdBlocks = await n2m.pageToMarkdown(pageId);
		const { parent: fullContent } = n2m.toMarkdownString(mdBlocks);

		const MAX_CHARS = 200_000;
		const truncated = fullContent.length > MAX_CHARS;
		const content = truncated
			? fullContent.slice(0, MAX_CHARS) +
				"\n\n...[内容已截断，超出 200,000 字符限制]"
			: fullContent;

		return {
			content,
			truncated,
			charCount: fullContent.length,
		};
	},
});
