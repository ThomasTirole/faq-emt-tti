export const sanitizeMarkdown = (text: string): string => {
    if (!text) return ''

    // Split by code blocks (triple backticks or single backticks)
    // We use a regex that captures the code blocks
    // The regex matches:
    // 1. Triple backticks code blocks: ```...```
    // 2. Single backtick inline code: `...`
    const codeBlockRegex = /(`{3}[\s\S]*?`{3}|`[^`]*`)/g

    const parts = text.split(codeBlockRegex)

    return parts.map(part => {
        // Check if the part matches the code block regex
        if (codeBlockRegex.test(part)) {
            return part
        } else {
            // Escape HTML tags in non-code parts
            return part
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
        }
    }).join('')
}
