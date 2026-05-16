import sys
import os
import json
import asyncio
from typing import Any, Dict, Optional
from mcp.server.fastmcp import FastMCP
from markitdown import MarkItDown

# Initialize FastMCP server
mcp = FastMCP("MarkItDown")
md = MarkItDown()

@mcp.tool()
def convert_to_markdown(path: str) -> str:
    """
    Convert various file formats (PDF, Docx, Xlsx, Pptx, HTML, etc.) to Markdown.
    
    :param path: The absolute or relative path to the file.
    :return: The converted Markdown content.
    """
    expanded_path = os.path.expanduser(path)
    if not os.path.exists(expanded_path):
        return f"Error: File not found at {expanded_path}"
    
    try:
        result = md.convert(expanded_path)
        return result.text_content
    except Exception as e:
        return f"Error during conversion: {str(e)}"

@mcp.resource("file://{path}")
def get_file_content(path: str) -> str:
    """
    Provide file content as Markdown resource. Automatically converts non-markdown files.
    """
    expanded_path = os.path.expanduser(path)
    if not os.path.exists(expanded_path):
        return "Error: File not found"
        
    ext = os.path.splitext(expanded_path)[1].lower()
    if ext in ['.md', '.txt']:
        with open(expanded_path, 'r', encoding='utf-8') as f:
            return f.read()
    
    try:
        result = md.convert(expanded_path)
        return result.text_content
    except:
        return "Error: Could not convert file to Markdown"

if __name__ == "__main__":
    mcp.run()
